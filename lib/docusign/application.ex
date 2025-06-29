defmodule DocuSign.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    # Apply runtime patches before starting the application
    apply_runtime_patches()

    children = children(get_app_env())

    opts = [strategy: :one_for_one, name: DocuSign.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children(:test) do
    [
      {Finch, name: DocuSign.Finch, pools: finch_pools()}
    ]
  end

  defp children(_env) do
    [
      {Finch, name: DocuSign.Finch, pools: finch_pools()},
      {DocuSign.ClientRegistry, []}
    ]
  end

  defp finch_pools do
    base_pools = %{
      default: [
        size: Application.get_env(:docusign, :pool_size, 10),
        count: Application.get_env(:docusign, :pool_count, 1)
      ]
    }

    # Only add SSL configuration if explicitly configured
    if Application.get_env(:docusign, :ssl_options) do
      add_ssl_to_pools(base_pools)
    else
      base_pools
    end
  end

  defp add_ssl_to_pools(pools) do
    if Code.ensure_loaded?(DocuSign.SSLOptions) do
      ssl_opts = DocuSign.SSLOptions.build()

      Map.update!(pools, :default, fn default_pool ->
        Keyword.put(default_pool, :conn_opts, transport_opts: ssl_opts)
      end)
    else
      pools
    end
  end

  defp get_app_env do
    Application.get_env(:docusign, :app_env, :prod)
  end

  @doc false
  def apply_runtime_patches do
    # The RequestBuilder now directly uses ModelCleaner
    if Code.ensure_loaded?(DocuSign.ModelCleaner) do
      Logger.info("✅ DocuSign: ModelCleaner integrated into RequestBuilder to fix INVALID_REQUEST_BODY errors")
    else
      Logger.warning("⚠️ DocuSign: ModelCleaner module not available, this may cause issues with API requests")
    end
  end
end
