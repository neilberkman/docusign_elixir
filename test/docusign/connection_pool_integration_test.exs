defmodule DocuSign.ConnectionPoolIntegrationTest do
  use ExUnit.Case, async: false

  alias DocuSign.{Connection, ConnectionPool}

  setup do
    # Save original config
    original_pool_opts = Application.get_env(:docusign, :pool_options)

    on_exit(fn ->
      # Restore original config
      if original_pool_opts do
        Application.put_env(:docusign, :pool_options, original_pool_opts)
      else
        Application.delete_env(:docusign, :pool_options)
      end
    end)

    :ok
  end

  describe "connection pooling configuration" do
    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    test "connection pooling is disabled by default", %{bypass: bypass} do
      Application.delete_env(:docusign, :pool_options)

      # Create connection
      oauth_client = %OAuth2.Client{
        token: %OAuth2.AccessToken{
          access_token: "test-token",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "http://localhost:#{bypass.port}"
        )

      # Should use default Req.Finch when pooling is not configured
      assert conn.req.options[:finch] == nil || conn.req.options[:finch] == Req.Finch
      assert ConnectionPool.enabled?() == false
    end

    test "connection uses custom Finch name when pooling is configured", %{bypass: bypass} do
      # Enable pooling (note: we won't actually start the Finch process in tests)
      Application.put_env(:docusign, :pool_options,
        size: 5,
        count: 1,
        max_idle_time: 60_000
      )

      # Verify pooling is enabled
      assert ConnectionPool.enabled?() == true

      config = ConnectionPool.config()
      assert config.size == 5
      assert config.count == 1
      assert config.max_idle_time == 60_000

      # Create connection
      oauth_client = %OAuth2.Client{
        token: %OAuth2.AccessToken{
          access_token: "test-token",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "http://localhost:#{bypass.port}"
        )

      # Should be configured to use custom DocuSign.Finch
      assert conn.req.options[:finch] == DocuSign.Finch
    end

    test "connection makes successful requests", %{bypass: bypass} do
      # Setup bypass to respond to requests
      Bypass.expect_once(bypass, "GET", "/test", fn conn ->
        Plug.Conn.send_resp(conn, 200, Jason.encode!(%{status: "ok"}))
      end)

      # Create connection
      oauth_client = %OAuth2.Client{
        token: %OAuth2.AccessToken{
          access_token: "test-token",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "http://localhost:#{bypass.port}"
        )

      # Make a request
      {:ok, response} = Connection.request(conn, method: :get, url: "/test")

      # Verify response
      assert response.status == 200
      # Body is returned as JSON string, decode it
      assert Jason.decode!(response.body) == %{"status" => "ok"}
    end

    test "pool health monitoring works" do
      # Test without pooling
      Application.delete_env(:docusign, :pool_options)
      assert {:error, :not_available} = ConnectionPool.health()

      # Test with pooling
      Application.put_env(:docusign, :pool_options, size: 10)

      assert {:ok, health} = ConnectionPool.health()
      assert health.status == :healthy
      assert health.message == "Connection pooling is active"
      assert is_map(health.config)
      assert health.config.size == 10
    end
  end

  describe "Finch configuration" do
    test "finch_pool_config builds correct structure" do
      Application.put_env(:docusign, :pool_options,
        size: 25,
        count: 2,
        max_idle_time: 120_000,
        timeout: 15_000
      )

      config = ConnectionPool.finch_pool_config()

      assert is_map(config)
      assert Map.has_key?(config, :default)
      assert config.default[:size] == 25
      assert config.default[:count] == 2
      assert config.default[:pool_max_idle_time] == 120_000
      assert config.default[:conn_opts][:timeout] == 15_000
    end

    test "finch_name returns correct name based on pooling" do
      # Without pooling
      Application.delete_env(:docusign, :pool_options)
      assert ConnectionPool.finch_name() == Req.Finch

      # With pooling
      Application.put_env(:docusign, :pool_options, size: 10)
      assert ConnectionPool.finch_name() == DocuSign.Finch
    end
  end
end
