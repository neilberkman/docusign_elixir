defmodule DocuSign.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  def start(_type, _args) do
    children = children(get_app_env())

    opts = [strategy: :one_for_one, name: DocuSign.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children(:test) do
    # In test mode, don't start anything as Req will handle its own
    []
  end

  defp children(_env) do
    # For all non-test environments, start the ClientRegistry
    # and optionally a custom Finch instance for connection pooling
    base_children = [
      {DocuSign.ClientRegistry, []}
    ]

    # Add custom Finch supervisor if connection pooling is enabled
    if DocuSign.ConnectionPool.enabled?() do
      finch_spec = {
        Finch,
        name: DocuSign.Finch, pools: DocuSign.ConnectionPool.finch_pool_config()
      }

      [finch_spec | base_children]
    else
      base_children
    end
  end

  defp get_app_env do
    Application.get_env(:docusign, :app_env, :prod)
  end
end
