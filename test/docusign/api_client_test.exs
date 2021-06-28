defmodule DocuSign.APIClientTest do
  use ExUnit.Case, async: false

  alias DocuSign.APIClient

  import DocuSign.ProcessHelper
  import Mox

  setup :set_mox_from_context
  setup :verify_on_exit!

  @oauth_mock __MODULE__.DocuSign.OAuth

  defmock(@oauth_mock, for: DocuSign.OAuth)

  setup do
    {:ok, pid} = DocuSign.APIClient.start_link()
    on_exit(fn -> assert_down(pid) end)
  end

  describe "creating a new client" do
    test "returns client for default user ID in app configuration" do
      @oauth_mock
      |> expect(:client, fn opts ->
        assert opts[:user_id] == ":user-id:"
        %OAuth2.Client{}
      end)
      |> expect(:refresh_token!, fn client, _force -> client end)
      |> expect(:interval_refresh_token, fn _client -> 1000 end)

      APIClient.client(oauth_impl: @oauth_mock)
    end

    test "returns client for given user ID" do
      @oauth_mock
      |> expect(:client, fn opts ->
        assert opts[:user_id] == ":another-user-id:"
        %OAuth2.Client{}
      end)
      |> expect(:refresh_token!, fn client, _force -> client end)
      |> expect(:interval_refresh_token, fn _client -> 1000 end)

      APIClient.client(":another-user-id:", oauth_impl: @oauth_mock)
    end
  end
end
