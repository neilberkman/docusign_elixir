defmodule DocuSign.ClientRegistryTest do
  use ExUnit.Case, async: false

  alias DocuSign.ClientRegistry

  import DocuSign.ProcessHelper
  import Mox

  setup :set_mox_from_context
  setup :verify_on_exit!

  @oauth_mock __MODULE__.DocuSign.OAuth

  defmock(@oauth_mock, for: DocuSign.OAuth)

  setup do
    {:ok, pid} = DocuSign.ClientRegistry.start_link()
    on_exit(fn -> assert_down(pid) end)
  end

  describe "creating a new client" do
    test "returns client for given user ID" do
      @oauth_mock
      |> expect(:client, fn opts ->
        assert opts[:user_id] == ":other-user-id:"
        %OAuth2.Client{}
      end)
      |> expect(:refresh_token!, fn client, _force -> client end)
      |> expect(:interval_refresh_token, fn _client -> 1000 end)

      ClientRegistry.client(":other-user-id:", oauth_impl: @oauth_mock)
    end

    test "2 user IDs returns 2 clients" do
      @oauth_mock
      |> expect(:client, 2, fn opts ->
        assert opts[:user_id] in [":user-id:", ":other-user-id:"]
        %OAuth2.Client{ref: %{user_id: opts[:user_id]}}
      end)
      |> expect(:refresh_token!, 2, fn client, _force -> client end)
      |> expect(:interval_refresh_token, 2, fn _client -> 1000 end)

      client_1 = ClientRegistry.client(":user-id:", oauth_impl: @oauth_mock)
      client_2 = ClientRegistry.client(":other-user-id:", oauth_impl: @oauth_mock)

      assert %OAuth2.Client{ref: %{user_id: ":user-id:"}} = client_1
      assert %OAuth2.Client{ref: %{user_id: ":other-user-id:"}} = client_2
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

      _client_to_refresh = ClientRegistry.client(":user-id:", oauth_impl: @oauth_mock)
      _client_not_to_refresh = ClientRegistry.client(":other-user-id:", oauth_impl: @oauth_mock)

      # Wait for refresh to occur (1sec)
      Process.sleep(1_500)
    end
  end
end
