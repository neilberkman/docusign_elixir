defmodule DocuSign.ClientRegistryTest do
  use ExUnit.Case, async: false

  import DocuSign.ProcessHelper
  import ExUnit.CaptureLog
  import Mox

  alias DocuSign.ClientRegistry

  setup :set_mox_from_context
  setup :verify_on_exit!

  @oauth_mock __MODULE__.DocuSign.OAuth

  defmock(@oauth_mock, for: DocuSign.OAuth)

  setup do
    {:ok, pid} = DocuSign.ClientRegistry.start_link(oauth_impl: @oauth_mock)
    on_exit(fn -> assert_down(pid) end)
    {:ok, registry: pid}
  end

  describe "creating a new client" do
    test "user ID returns new client" do
      @oauth_mock
      |> expect(:client, fn opts ->
        assert opts[:user_id] == ":user-id:"
        %OAuth2.Client{}
      end)
      |> expect(:refresh_token!, fn client, _force -> client end)
      |> expect(:interval_refresh_token, fn _client -> 1000 end)

      {:ok, _client} = ClientRegistry.client(":user-id:")
    end

    test "2 user IDs creates 2 clients" do
      @oauth_mock
      |> expect(:client, 2, fn opts ->
        assert opts[:user_id] in [":user-id:", ":other-user-id:"]
        %OAuth2.Client{ref: %{user_id: opts[:user_id]}}
      end)
      |> expect(:refresh_token!, 2, fn client, _force -> client end)
      |> expect(:interval_refresh_token, 2, fn _client -> 1000 end)

      {:ok, client_1} = ClientRegistry.client(":user-id:")
      {:ok, client_2} = ClientRegistry.client(":other-user-id:")

      assert %OAuth2.Client{ref: %{user_id: ":user-id:"}} = client_1
      assert %OAuth2.Client{ref: %{user_id: ":other-user-id:"}} = client_2
    end

    test "OAuth2 exception is returned in an error tuple" do
      @oauth_mock
      |> expect(:client, fn opts ->
        assert opts[:user_id] == ":user-id:"
        %OAuth2.Client{}
      end)
      |> expect(:refresh_token!, fn _client, _force -> raise %OAuth2.Error{} end)

      {:error, error} = ClientRegistry.client(":user-id:")

      assert %OAuth2.Error{} = error
    end
  end

  describe "getting a client" do
    test "user ID returns cached client" do
      @oauth_mock
      |> expect(:client, fn opts ->
        assert opts[:user_id] == ":user-id:"
        %OAuth2.Client{}
      end)
      |> expect(:refresh_token!, fn client, _force -> client end)
      |> expect(:interval_refresh_token, fn _client -> 1000 end)
      |> expect(:refresh_token!, fn client -> client end)

      {:ok, _created_client} = ClientRegistry.client(":user-id:")
      {:ok, _cached_client} = ClientRegistry.client(":user-id:")
    end
  end

  describe "automatically refreshing access token" do
    test "failed refresh keeps the registry alive and rebuilds the client", %{registry: pid} do
      user_id = "refresh-failure-user"
      cached_client = %OAuth2.Client{token: %OAuth2.AccessToken{access_token: "CACHED-SECRET-TOKEN"}}
      rebuilt_client = %OAuth2.Client{token: %OAuth2.AccessToken{access_token: "REBUILT-TOKEN"}}

      @oauth_mock
      |> expect(:client, fn [user_id: ^user_id] -> cached_client end)
      |> expect(:refresh_token!, fn ^cached_client, true -> cached_client end)
      |> expect(:interval_refresh_token, fn ^cached_client -> 1000 end)
      |> expect(:refresh_token!, fn ^cached_client, true ->
        raise %OAuth2.Error{reason: :econnrefused}
      end)

      assert {:ok, ^cached_client} = ClientRegistry.client(user_id)

      log =
        capture_log(fn ->
          send(pid, {:refresh_token, user_id})
          assert %ClientRegistry.State{clients: clients} = :sys.get_state(pid)
          refute Map.has_key?(clients, user_id)
          assert Process.alive?(pid)
        end)

      assert log =~ "[warning]"
      assert log =~ user_id
      assert log =~ "Connection refused"
      refute log =~ cached_client.token.access_token

      @oauth_mock
      |> expect(:client, fn [user_id: ^user_id] -> rebuilt_client end)
      |> expect(:refresh_token!, fn ^rebuilt_client, true -> rebuilt_client end)
      |> expect(:interval_refresh_token, fn ^rebuilt_client -> 1000 end)

      assert {:ok, ^rebuilt_client} = ClientRegistry.client(user_id)
    end

    test "refresh for an unknown user leaves the registry unchanged", %{registry: pid} do
      state = :sys.get_state(pid)
      send(pid, {:refresh_token, "unknown-user"})
      assert :sys.get_state(pid) == state
      assert Process.alive?(pid)
    end

    test "negative refresh intervals schedule an immediate refresh", %{registry: pid} do
      test_pid = self()

      @oauth_mock
      |> expect(:client, fn _opts -> %OAuth2.Client{} end)
      |> expect(:refresh_token!, 3, fn client, true -> client end)
      |> expect(:interval_refresh_token, 2, fn _client -> -5 end)
      |> expect(:interval_refresh_token, fn _client ->
        send(test_pid, :refreshed)
        1000
      end)

      assert {:ok, %OAuth2.Client{}} = ClientRegistry.client("short-lived-token-user")
      assert_receive :refreshed

      assert %ClientRegistry.State{clients: %{"short-lived-token-user" => %OAuth2.Client{}}} =
               :sys.get_state(pid)

      assert Process.alive?(pid)
    end

    test "client access token is refreshed after delay" do
      # 2 refreshes when clients are created, and 1 when a client gets refreshed
      expected_force_token_refresh_count = 3

      @oauth_mock
      |> expect(:client, 2, fn opts -> %OAuth2.Client{ref: %{user_id: opts[:user_id]}} end)
      |> expect(:refresh_token!, expected_force_token_refresh_count, fn client, true -> client end)
      |> expect(:interval_refresh_token, 3, fn %{ref: %{user_id: user_id}} ->
        case user_id do
          ":user-id:" -> 1
          _ -> 60
        end
      end)

      {:ok, _client_to_refresh} = ClientRegistry.client(":user-id:")
      {:ok, _client_not_to_refresh} = ClientRegistry.client(":other-user-id:")

      # Wait for refresh to occur (1sec)
      Process.sleep(1_500)
    end
  end

  test "inspecting state exposes only the implementation and user IDs" do
    client = %OAuth2.Client{
      client_secret: "STATE-CLIENT-SECRET",
      token: %OAuth2.AccessToken{
        access_token: "STATE-SECRET-TOKEN",
        refresh_token: "STATE-REFRESH-TOKEN"
      }
    }

    inspected = inspect(%ClientRegistry.State{clients: %{"u" => client}, oauth_impl: @oauth_mock})

    assert inspected =~ inspect(@oauth_mock)
    assert inspected =~ ~s(user_ids: ["u"])
    refute inspected =~ "STATE-CLIENT-SECRET"
    refute inspected =~ "STATE-SECRET-TOKEN"
    refute inspected =~ "STATE-REFRESH-TOKEN"
  end
end
