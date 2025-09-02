defmodule DocuSign.ConnectionPoolTest do
  use ExUnit.Case, async: false

  alias DocuSign.ConnectionPool

  setup do
    # Save original config
    original_pool_opts = Application.get_env(:docusign, :pool_options)
    original_ssl_opts = Application.get_env(:docusign, :ssl_options)

    on_exit(fn ->
      # Restore original config
      if original_pool_opts do
        Application.put_env(:docusign, :pool_options, original_pool_opts)
      else
        Application.delete_env(:docusign, :pool_options)
      end

      if original_ssl_opts do
        Application.put_env(:docusign, :ssl_options, original_ssl_opts)
      else
        Application.delete_env(:docusign, :ssl_options)
      end
    end)

    :ok
  end

  describe "enabled?/0" do
    test "returns true when pool options are configured" do
      Application.put_env(:docusign, :pool_options, size: 20)
      assert ConnectionPool.enabled?() == true
    end

    test "returns false when pool options are not configured" do
      Application.delete_env(:docusign, :pool_options)
      assert ConnectionPool.enabled?() == false
    end
  end

  describe "config/0" do
    test "returns default configuration when not configured" do
      Application.delete_env(:docusign, :pool_options)

      config = ConnectionPool.config()
      assert config.size == 10
      assert config.count == 1
      assert config.max_idle_time == 300_000
      assert config.timeout == 30_000
      assert config.enabled == false
    end

    test "returns custom configuration when configured" do
      Application.put_env(:docusign, :pool_options,
        size: 50,
        count: 2,
        max_idle_time: 600_000,
        timeout: 60_000
      )

      config = ConnectionPool.config()
      assert config.size == 50
      assert config.count == 2
      assert config.max_idle_time == 600_000
      assert config.timeout == 60_000
      assert config.enabled == true
    end

    test "returns partial custom configuration with defaults" do
      Application.put_env(:docusign, :pool_options, size: 25)

      config = ConnectionPool.config()
      assert config.size == 25
      # default
      assert config.count == 1
      # default
      assert config.max_idle_time == 300_000
      # default
      assert config.timeout == 30_000
      assert config.enabled == true
    end
  end

  describe "health/0" do
    test "returns healthy status when pooling is enabled" do
      Application.put_env(:docusign, :pool_options, size: 20)

      assert {:ok, health} = ConnectionPool.health()
      assert health.status == :healthy
      assert health.message == "Connection pooling is active"
      assert is_map(health.config)
    end

    test "returns error when pooling is not enabled" do
      Application.delete_env(:docusign, :pool_options)

      assert {:error, :not_available} = ConnectionPool.health()
    end
  end

  describe "finch_pool_config/0" do
    test "builds correct Finch pool configuration" do
      Application.put_env(:docusign, :pool_options,
        size: 30,
        count: 3,
        max_idle_time: 400_000,
        timeout: 45_000
      )

      config = ConnectionPool.finch_pool_config()

      assert config.default[:size] == 30
      assert config.default[:count] == 3
      assert config.default[:pool_max_idle_time] == 400_000
      assert config.default[:conn_opts][:timeout] == 45_000
    end

    test "includes SSL options when configured" do
      Application.put_env(:docusign, :pool_options, size: 10)

      # Use a valid system cert path or configure to skip validation
      cert_path =
        [
          "/etc/ssl/cert.pem",
          "/etc/ssl/certs/ca-certificates.crt",
          "/etc/ssl/certs/ca-bundle.crt"
        ]
        |> Enum.find(&File.exists?/1)

      if cert_path do
        Application.put_env(:docusign, :ssl_options,
          cacertfile: cert_path,
          verify: :verify_peer
        )

        config = ConnectionPool.finch_pool_config()

        assert config.default[:conn_opts][:transport_opts]
        assert config.default[:conn_opts][:transport_opts][:cacertfile] == cert_path
        assert config.default[:conn_opts][:transport_opts][:verify] == :verify_peer
      else
        # Skip test if no system certs are available
        Application.put_env(:docusign, :ssl_options, verify: :verify_peer)

        config = ConnectionPool.finch_pool_config()

        assert config.default[:conn_opts][:transport_opts]
        assert config.default[:conn_opts][:transport_opts][:verify] == :verify_peer
      end
    end
  end

  describe "finch_name/0" do
    test "returns custom Finch name when pooling is enabled" do
      Application.put_env(:docusign, :pool_options, size: 20)
      assert ConnectionPool.finch_name() == DocuSign.Finch
    end

    test "returns default Req.Finch when pooling is disabled" do
      Application.delete_env(:docusign, :pool_options)
      assert ConnectionPool.finch_name() == Req.Finch
    end
  end

  describe "integration with Connection" do
    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    test "connection uses custom Finch when pooling is enabled", %{bypass: bypass} do
      Application.put_env(:docusign, :pool_options, size: 15)

      # Create a connection
      oauth_client = %OAuth2.Client{
        token: %OAuth2.AccessToken{
          access_token: "test-token",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        DocuSign.Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "http://localhost:#{bypass.port}"
        )

      # Check that the connection is configured with custom Finch
      assert conn.req.options[:finch] == DocuSign.Finch
    end

    test "connection uses default Finch when pooling is disabled", %{bypass: bypass} do
      Application.delete_env(:docusign, :pool_options)

      # Create a connection
      oauth_client = %OAuth2.Client{
        token: %OAuth2.AccessToken{
          access_token: "test-token",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        DocuSign.Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "http://localhost:#{bypass.port}"
        )

      # Check that the connection uses default Finch (nil or Req.Finch)
      assert conn.req.options[:finch] == nil || conn.req.options[:finch] == Req.Finch
    end
  end
end
