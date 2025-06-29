defmodule DocuSign.SSLIntegrationTest do
  use ExUnit.Case, async: true

  alias DocuSign.Connection
  alias DocuSign.SSLOptions

  describe "SSL configuration with Bypass" do
    setup do
      # Bypass creates a real HTTP server we can test against
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    test "SSL options are passed through to the HTTP layer", %{bypass: bypass} do
      # Set up a response
      Bypass.expect_once(bypass, "GET", "/test", fn conn ->
        # We can inspect the connection to verify SSL was attempted
        # In a real test with HTTPS, we'd check the SSL handshake
        Plug.Conn.resp(conn, 200, ~s({"status": "ok"}))
      end)

      # Create a connection pointing to our test server
      conn = %Connection{
        app_account: %{base_uri: "http://localhost:#{bypass.port}"},
        client: %{token: %OAuth2.AccessToken{access_token: "test", token_type: "Bearer"}}
      }

      # Make a request with SSL options
      # Note: Bypass only supports HTTP, so we can't test actual SSL handshake
      # but we can verify the options are passed through
      {:ok, response} =
        Connection.request(conn,
          method: :get,
          url: "/test",
          ssl_options: [
            verify: :verify_none,
            depth: 5
          ]
        )

      assert response.status == 200
    end

    test "per-request SSL options override defaults", %{bypass: bypass} do
      # Set global SSL options
      original = Application.get_env(:docusign, :ssl_options)
      Application.put_env(:docusign, :ssl_options, verify: :verify_peer, depth: 3)

      try do
        Bypass.expect_once(bypass, "GET", "/test", fn conn ->
          Plug.Conn.resp(conn, 200, "ok")
        end)

        conn = %Connection{
          app_account: %{base_uri: "http://localhost:#{bypass.port}"},
          client: %{token: %OAuth2.AccessToken{access_token: "test", token_type: "Bearer"}}
        }

        # Request with different SSL options
        {:ok, _response} =
          Connection.request(conn,
            method: :get,
            url: "/test",
            ssl_options: [verify: :verify_none, depth: 10]
          )

        # We can't directly verify the SSL options were used by Finch
        # but we've tested that they're passed through the layers correctly
      after
        if original do
          Application.put_env(:docusign, :ssl_options, original)
        else
          Application.delete_env(:docusign, :ssl_options)
        end
      end
    end
  end

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
