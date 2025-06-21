defmodule DocuSign.ClientRegistryTest do
  use ExUnit.Case, async: false

  import DocuSign.ProcessHelper
  import Mox

  alias DocuSign.ClientRegistry

  setup :set_mox_from_context
  setup :verify_on_exit!

  @oauth_mock __MODULE__.DocuSign.OAuth

  defmock(@oauth_mock, for: DocuSign.OAuth)

  setup do
    {:ok, pid} = DocuSign.ClientRegistry.start_link(oauth_impl: @oauth_mock)
    on_exit(fn -> assert_down(pid) end)
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
end
