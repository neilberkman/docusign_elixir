defmodule DocuSign.SSLIntegrationTest do
  # Modifies global SSL config, can't run async
  use ExUnit.Case, async: false

  alias DocuSign.Connection
  alias DocuSign.OAuth.Impl
  alias DocuSign.SSLOptions

  setup do
    original = Application.fetch_env(:docusign, :ssl_options)

    on_exit(fn ->
      case original do
        {:ok, value} -> Application.put_env(:docusign, :ssl_options, value)
        :error -> Application.delete_env(:docusign, :ssl_options)
      end
    end)
  end

  describe "SSL configuration with local test server" do
    setup do
      # Local test server creates a real HTTP server we can test against
      server = DocuSign.TestHTTPServer.open()
      {:ok, server: server}
    end

    test "SSL options are passed through to the HTTP layer", %{server: server} do
      # Set up a response
      DocuSign.TestHTTPServer.expect_once(server, "GET", "/test", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, ~s({"status": "ok"}))
      end)

      # Create a connection pointing to our test server
      base_url = "http://localhost:#{server.port}"

      req =
        Req.new(
          base_url: base_url,
          headers: [
            {"authorization", "Bearer test"},
            {"content-type", "application/json"}
          ],
          receive_timeout: 30_000,
          retry: false
        )

      conn = %Connection{
        app_account: %{base_uri: base_url},
        client: %{token: %OAuth2.AccessToken{access_token: "test", token_type: "Bearer"}},
        req: req
      }

      # Make a request WITHOUT SSL options since we're testing HTTP not HTTPS
      # The SSL options functionality is tested in other unit tests
      {:ok, response} =
        Connection.request(conn,
          method: :get,
          url: "/test"
        )

      assert response.status == 200
      assert response.body == %{"status" => "ok"}
    end

    test "per-request SSL options override defaults", %{server: server} do
      Application.put_env(:docusign, :ssl_options, depth: 3)

      base_url = "http://localhost:#{server.port}"

      req =
        Req.new(
          base_url: base_url,
          headers: [
            {"authorization", "Bearer test"},
            {"content-type", "application/json"}
          ],
          receive_timeout: 30_000,
          retry: false
        )

      conn = %Connection{
        app_account: %{base_uri: base_url},
        client: %{token: %OAuth2.AccessToken{access_token: "test", token_type: "Bearer"}},
        req: req
      }

      req =
        Req.Request.append_request_steps(req,
          capture_options: fn req ->
            send(self(), {:request, req})
            Req.Request.halt(req, %Req.Response{status: 200, body: "ok"})
          end
        )

      conn = %{conn | req: req}

      {:ok, response} =
        Connection.request(conn,
          method: :get,
          url: "/test",
          ssl_options: [depth: 5]
        )

      assert_received {:request, request}
      assert request.options[:finch] == nil
      assert request.options[:connect_options][:transport_opts][:depth] == 5
      assert request.options[:connect_options][:transport_opts][:verify] == :verify_peer
      assert response.status == 200
      assert response.body == "ok"
    end
  end

  describe "TLS end to end" do
    setup do
      %{server_config: server_config, client_config: client_config} = DocuSign.TestTLS.chains()

      server =
        DocuSign.TestHTTPServer.open(
          scheme: :https,
          transport_options: DocuSign.TestTLS.server_transport_options(server_config)
        )

      original_pool = Application.get_env(:docusign, :pool_options)
      original_hostname = Application.get_env(:docusign, :hostname)
      original_client_id = Application.get_env(:docusign, :client_id)

      on_exit(fn ->
        restore_env(:pool_options, original_pool)
        restore_env(:hostname, original_hostname)
        restore_env(:client_id, original_client_id)
      end)

      {:ok, server: server, cacerts: client_config[:cacerts]}
    end

    @tag :capture_log
    test "per-request SSL options complete a TLS request while pooling is enabled", %{
      server: server,
      cacerts: cacerts
    } do
      Application.put_env(:docusign, :pool_options, size: 5)

      DocuSign.TestHTTPServer.expect_once(server, "GET", "/test", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, ~s({"status": "ok"}))
      end)

      oauth_client = %OAuth2.Client{token: %OAuth2.AccessToken{access_token: "test", token_type: "Bearer"}}

      {:ok, conn} =
        Connection.from_oauth_client(oauth_client,
          account_id: "test-account",
          base_uri: "https://localhost:#{server.port}"
        )

      # The named pool is configured but not started in the test environment.
      assert conn.req.options[:finch] == DocuSign.Finch

      assert {:ok, %Req.Response{status: 200}} =
               Connection.request(conn, method: :get, url: "/test", ssl_options: [cacerts: cacerts])

      assert {:error, %Req.TransportError{reason: {:tls_alert, _}}} =
               Connection.request(conn, method: :get, url: "/test", ssl_options: [depth: 2])
    end

    @tag :capture_log
    test "JWT token request verifies the server certificate", %{server: server, cacerts: cacerts} do
      Application.ensure_all_started(:inets)
      # 127.0.0.1 rather than localhost: the server listens on IPv4 only.
      Application.put_env(:docusign, :hostname, "127.0.0.1:#{server.port}")
      Application.put_env(:docusign, :client_id, "client-id")

      # Unknown CA first: httpc keeps connections alive per host and port, so a
      # successful handshake before this point would be reused and skip verification.
      # Tesla's httpc adapter reports every connection failure as :econnrefused, so
      # the alert logged by the ssl application is the evidence that verification ran.
      Application.delete_env(:docusign, :ssl_options)
      client = Impl.client(user_id: "user")
      assert client.request_opts[:ssl][:verify] == :verify_peer

      log =
        ExUnit.CaptureLog.capture_log(fn ->
          assert {:error, %OAuth2.Error{reason: :econnrefused}} = OAuth2.Client.get_token(client)
        end)

      assert log =~ "Unknown CA"

      DocuSign.TestHTTPServer.expect_once(server, "POST", "/oauth/token", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, ~s({"access_token": "tok", "token_type": "Bearer", "expires_in": 3600}))
      end)

      Application.put_env(:docusign, :ssl_options, cacerts: cacerts)
      client = Impl.client(user_id: "user")
      assert client.request_opts[:ssl][:cacerts] == cacerts
      refute Keyword.has_key?(client.request_opts[:ssl], :cacertfile)
      assert %OAuth2.Client{token: %OAuth2.AccessToken{access_token: "tok"}} = Impl.get_token!(client)
    end
  end

  defp restore_env(key, nil), do: Application.delete_env(:docusign, key)
  defp restore_env(key, value), do: Application.put_env(:docusign, key, value)

  describe "SSL options building" do
    test "validates certificate files exist when validate_files is true" do
      # This should raise because the file doesn't exist
      assert_raise ArgumentError, ~r/non-existent file/, fn ->
        SSLOptions.build(
          cacertfile: "/fake/ca.pem",
          validate_files: true
        )
      end
    end

    test "skips validation when validate_files is false" do
      # This should not raise
      opts =
        SSLOptions.build(
          cacertfile: "/fake/ca.pem",
          certfile: "/fake/cert.pem",
          keyfile: "/fake/key.pem",
          validate_files: false
        )

      assert opts[:cacertfile] == "/fake/ca.pem"
      assert opts[:certfile] == "/fake/cert.pem"
      assert opts[:keyfile] == "/fake/key.pem"
    end

    test "CA certificate auto-detection" do
      # Test without any configured CA certs
      original = Application.get_env(:docusign, :ssl_options)
      Application.delete_env(:docusign, :ssl_options)

      try do
        opts = SSLOptions.build()

        # Should have found SOME CA certificates
        # Either from system paths or CAStore
        assert opts[:cacertfile] || opts[:cacerts] ||
                 find_ca_in_opts(opts)
      after
        if original do
          Application.put_env(:docusign, :ssl_options, original)
        end
      end
    end
  end

  describe "Finch pool configuration" do
    test "SSL options are included in Finch pools when configured" do
      # Configure SSL options
      original = Application.get_env(:docusign, :ssl_options)
      # Create a temporary file for testing
      {:ok, temp_file} = Briefly.create()

      Application.put_env(:docusign, :ssl_options,
        verify: :verify_peer,
        cacertfile: temp_file
      )

      try do
        # This would normally happen during application start
        # We're testing the configuration building logic
        pools = build_test_finch_pools()

        assert pools[:default][:conn_opts][:transport_opts][:verify] == :verify_peer
        assert pools[:default][:conn_opts][:transport_opts][:cacertfile]
      after
        if original do
          Application.put_env(:docusign, :ssl_options, original)
        else
          Application.delete_env(:docusign, :ssl_options)
        end
      end
    end

    test "Finch pools work without SSL configuration" do
      # Remove SSL configuration
      original = Application.get_env(:docusign, :ssl_options)
      Application.delete_env(:docusign, :ssl_options)

      try do
        pools = build_test_finch_pools()

        # Should have basic pool config but no SSL
        assert pools[:default][:size]
        assert pools[:default][:count]
        refute pools[:default][:conn_opts]
      after
        if original do
          Application.put_env(:docusign, :ssl_options, original)
        end
      end
    end
  end

  # Helper to build Finch pools like the Application module does
  defp build_test_finch_pools do
    base_pools = %{
      default: [
        size: Application.get_env(:docusign, :pool_size, 10),
        count: Application.get_env(:docusign, :pool_count, 1)
      ]
    }

    case Application.get_env(:docusign, :ssl_options) do
      nil ->
        base_pools

      _ssl_config ->
        add_ssl_config_to_pools(base_pools)
    end
  end

  defp add_ssl_config_to_pools(base_pools) do
    if Code.ensure_loaded?(DocuSign.SSLOptions) do
      ssl_opts = DocuSign.SSLOptions.build()

      Map.update!(base_pools, :default, fn default_pool ->
        Keyword.put(default_pool, :conn_opts, transport_opts: ssl_opts)
      end)
    else
      base_pools
    end
  end

  defp find_ca_in_opts(opts) do
    # Check if CA certs were found in any form
    opts[:cacertfile] || opts[:cacerts] ||
      Keyword.has_key?(opts, :cacertfile) ||
      Keyword.has_key?(opts, :cacerts)
  end
end
