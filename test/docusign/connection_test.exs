defmodule DocuSign.ConnectionTest do
  use ExUnit.Case, async: false

  import DocuSign.EnvHelper
  import DocuSign.ProcessHelper
  import Mox

  alias DocuSign.Connection
  alias DocuSign.User.AppAccount

  setup :set_mox_from_context
  setup :verify_on_exit!

  @oauth_mock __MODULE__.DocuSign.OAuth

  defmock(@oauth_mock, for: DocuSign.OAuth)

  # Deprecated functions removed in v2.0.0
  # Note: The tests for Connection.new() have been replaced with tests using Connection.get()

  describe "getting a new connection for a user ID" do
    setup do
      {:ok, pid} = DocuSign.ClientRegistry.start_link(oauth_impl: @oauth_mock)
      on_exit(fn -> assert_down(pid) end)
    end

    test "user ID returns connection for that user" do
      @oauth_mock
      |> expect(:client, fn opts ->
        assert opts[:user_id] == ":user-id:"
        %OAuth2.Client{ref: %{user_id: opts[:user_id]}}
      end)
      |> expect(:refresh_token!, fn client, _force -> client end)
      |> expect(:interval_refresh_token, fn _client -> 1000 end)

      {:ok, connection} = Connection.get(":user-id:")

      assert connection.client.ref.user_id == ":user-id:"
    end

    test "consent required OAuth error returns error :consent_required" do
      # Set required config for build_consent_url
      Application.put_env(:docusign, :client_id, "test-client-id")
      Application.put_env(:docusign, :hostname, "test.docusign.com")

      on_exit(fn ->
        Application.delete_env(:docusign, :client_id)
        Application.delete_env(:docusign, :hostname)
      end)

      @oauth_mock
      |> expect(:client, fn opts ->
        %OAuth2.Client{ref: %{user_id: opts[:user_id]}}
      end)
      |> expect(:refresh_token!, fn _client, _force ->
        raise %OAuth2.Error{reason: "...\"consent_required\"..."}
      end)

      {:error, error} = Connection.get(":user-id:")

      assert {:consent_required, _message} = error

      {:consent_required, message} = error
      assert message =~ "Ask user to visit this URL to consent impersonation: https://"
    end

    test "unrecoverable OAuth error returns error" do
      @oauth_mock
      |> expect(:client, fn opts ->
        %OAuth2.Client{ref: %{user_id: opts[:user_id]}}
      end)
      |> expect(:refresh_token!, fn _client, _force -> raise %OAuth2.Error{} end)

      result = Connection.get(":user-id:")

      assert {:error, %OAuth2.Error{}} = result
    end
  end

  describe "requesting with a configured timeout" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "request without timeout returns payload", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, "")
      end)

      result = do_request(bypass)

      refute result == :timeout
    end

    test "request with timeout less than 2s returns :timeout", %{bypass: bypass} do
      # By default, Mint times out after 2s
      put_env(:docusign, :timeout, 500)

      Bypass.expect_once(bypass, fn conn ->
        Process.sleep(1_000)
        Plug.Conn.resp(conn, 200, "")
      end)

      result = do_request(bypass)

      assert {:error, %Req.TransportError{reason: :timeout}} = result

      # Force bypass expectations to pass to prevent exit :shutdown error
      Bypass.pass(bypass)
    end
  end

  defp do_request(bypass) do
    # Create a proper connection with Req client
    app_account = %AppAccount{base_uri: "http://localhost:#{bypass.port}"}
    client = %{token: %OAuth2.AccessToken{access_token: "test-token", token_type: "Bearer"}}

    # Build Req client
    req =
      Req.new(
        base_url: app_account.base_uri,
        headers: [
          {"authorization", "Bearer test-token"},
          {"content-type", "application/json"}
        ],
        receive_timeout: Application.get_env(:docusign, :timeout, 30_000),
        retry: false
      )

    conn = %Connection{
      app_account: app_account,
      client: client,
      req: req
    }

    opts = [method: :get, url: "/endpoint"]

    Connection.request(conn, opts)
  end
end
