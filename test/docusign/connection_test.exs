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

  test "inspecting a connection hides OAuth credentials" do
    oauth_client = %OAuth2.Client{
      client_secret: "SECRET-CLIENT-SECRET",
      token: %OAuth2.AccessToken{
        access_token: "SECRET-TOKEN",
        refresh_token: "SECRET-REFRESH-TOKEN",
        token_type: "Bearer"
      }
    }

    {:ok, conn} =
      Connection.from_oauth_client(oauth_client,
        account_id: "test-account",
        base_uri: "https://demo.docusign.net/restapi"
      )

    inspected = inspect(conn)

    assert inspected =~ "Req.Request"
    refute inspected =~ "SECRET-TOKEN"
    refute inspected =~ "SECRET-CLIENT-SECRET"
    refute inspected =~ "SECRET-REFRESH-TOKEN"
  end

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
      put_env(:docusign, :client_id, "test-client-id")
      put_env(:docusign, :hostname, "test.docusign.com")

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
      server = DocuSign.TestHTTPServer.open()

      {:ok, server: server}
    end

    test "request without timeout returns payload", %{server: server} do
      DocuSign.TestHTTPServer.expect_once(server, fn conn ->
        Plug.Conn.resp(conn, 200, "")
      end)

      result = do_request(server)

      assert {:ok, %Req.Response{status: 200}} = result
    end

    test "request with timeout less than 2s returns :timeout", %{server: server} do
      # By default, Mint times out after 2s
      put_env(:docusign, :timeout, 500)

      DocuSign.TestHTTPServer.expect_once(server, fn conn ->
        Process.sleep(1_000)
        Plug.Conn.resp(conn, 200, "")
      end)

      result = do_request(server)

      assert {:error, %Req.TransportError{reason: :timeout}} = result

      # Force server expectations to pass to prevent exit :shutdown error
      DocuSign.TestHTTPServer.pass(server)
    end
  end

  describe "request URL validation" do
    setup do
      req = Req.new(base_url: "https://demo.docusign.net/restapi", auth: {:bearer, "test-token"})
      {:ok, conn: %Connection{req: req}}
    end

    test "rejects absolute and host-relative URLs before running the request", %{conn: conn} do
      req =
        Req.Request.prepend_request_steps(conn.req,
          reject_request: fn _req -> flunk("absolute URL reached the request steps") end
        )

      for url <- ["https://attacker.example/x", "//attacker.example/x", "mailto:attacker@example.com"] do
        assert_raise ArgumentError,
                     "absolute URL not allowed; pass a path relative to the connection's base URI",
                     fn ->
                       Connection.request(%{conn | req: req},
                         url: url,
                         ssl_options: [cacertfile: "/nonexistent/cert.pem"]
                       )
                     end
      end
    end

    test "accepts a relative API path", %{conn: conn} do
      req =
        Req.Request.append_request_steps(conn.req,
          check_request: fn req ->
            assert URI.to_string(req.url) == "https://demo.docusign.net/restapi/v2.1/accounts"
            assert Req.Request.get_header(req, "authorization") == ["Bearer test-token"]
            Req.Request.halt(req, %Req.Response{status: 200, body: "ok"})
          end
        )

      assert {:ok, %Req.Response{status: 200}} =
               Connection.request(%{conn | req: req}, url: "/v2.1/accounts")
    end
  end

  defp do_request(server) do
    base_url = "http://localhost:#{server.port}"
    timeout = Application.get_env(:docusign, :timeout, 30_000)

    req =
      Req.new(
        base_url: base_url,
        headers: [
          {"authorization", "Bearer "},
          {"content-type", "application/json"}
        ],
        receive_timeout: timeout,
        retry: false
      )

    conn = %Connection{
      app_account: %AppAccount{base_uri: base_url},
      client: %{token: %OAuth2.AccessToken{}},
      req: req
    }

    opts = [method: :get, url: "/endpoint"]

    Connection.request(conn, opts)
  end
end
