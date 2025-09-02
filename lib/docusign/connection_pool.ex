defmodule DocuSign.ConnectionPool do
  @moduledoc """
  Connection pooling configuration for high-throughput DocuSign applications.

  This module optimizes HTTP connection management by reusing connections
  and managing pool sizes for better performance under load.

  ## Configuration

  Configure connection pools in your application config:

      config :docusign, :pool_options, [
        size: 10,                # Connections per pool (default: 10)
        count: 1,                # Number of pools (default: 1)
        max_idle_time: 300_000,  # Max idle time in ms (default: 5 minutes)
        timeout: 30_000          # Connection timeout (default: 30s)
      ]

  ## Pool Strategy

  Connections are pooled per endpoint:
  - Production: pools for `na3.docusign.net`, `na4.docusign.net`, etc.
  - Sandbox: pools for `demo.docusign.net`

  ## Performance Tuning

  - **size**: Number of connections kept open to each endpoint
  - **count**: Number of parallel pools for concurrent request handling
  - **max_idle_time**: How long idle connections stay open
  - **timeout**: Maximum time to establish a connection

  ## Examples

      # High-throughput configuration
      config :docusign, :pool_options, [
        size: 50,                # More connections
        count: 2,                # Multiple pools for concurrency
        max_idle_time: 600_000   # Keep connections alive longer
      ]

      # Conservative configuration
      config :docusign, :pool_options, [
        size: 5,
        count: 1,
        max_idle_time: 60_000    # Close idle connections quickly
      ]
  """

  @default_pool_size 10
  @default_pool_count 1
  # 5 minutes
  @default_max_idle_time 300_000
  # 30 seconds
  @default_conn_timeout 30_000

  @doc """
  Check if connection pooling is enabled.

  Returns true if custom pool options are configured.
  """
  @spec enabled?() :: boolean()
  def enabled? do
    Application.get_env(:docusign, :pool_options) != nil
  end

  @doc """
  Get current pool configuration.

  Returns the active pool configuration for inspection.
  """
  @spec config() :: map()
  def config do
    pool_opts = Application.get_env(:docusign, :pool_options, [])

    %{
      count: pool_opts[:count] || @default_pool_count,
      enabled: enabled?(),
      max_idle_time: pool_opts[:max_idle_time] || @default_max_idle_time,
      size: pool_opts[:size] || @default_pool_size,
      timeout: pool_opts[:timeout] || @default_conn_timeout
    }
  end

  @doc """
  Get pool health metrics.

  Returns connection pool statistics for monitoring.
  """
  @spec health() :: {:ok, map()} | {:error, :not_available}
  def health do
    if enabled?() do
      {:ok,
       %{
         config: config(),
         message: "Connection pooling is active",
         status: :healthy
       }}
    else
      {:error, :not_available}
    end
  end

  @doc false
  # Internal function for building Finch pool options
  # This is used by the Application supervisor
  def finch_pool_config do
    pool_opts = Application.get_env(:docusign, :pool_options, [])

    %{
      default: [
        size: pool_opts[:size] || @default_pool_size,
        count: pool_opts[:count] || @default_pool_count,
        pool_max_idle_time: pool_opts[:max_idle_time] || @default_max_idle_time,
        conn_opts: build_conn_opts(pool_opts)
      ]
    }
  end

  @doc false
  # Internal function to get the Finch name
  def finch_name do
    if enabled?() do
      DocuSign.Finch
    else
      # Use default Req Finch when pooling is disabled
      Req.Finch
    end
  end

  defp build_conn_opts(pool_opts) do
    timeout = pool_opts[:timeout] || @default_conn_timeout

    base_opts = [timeout: timeout]

    # Add SSL options if configured
    if Application.get_env(:docusign, :ssl_options) do
      # Build SSL options using the SSLOptions module
      ssl_opts = DocuSign.SSLOptions.build()
      base_opts ++ [transport_opts: ssl_opts]
    else
      base_opts
    end
  end
end
