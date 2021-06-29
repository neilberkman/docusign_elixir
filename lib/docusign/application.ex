defmodule DocuSign.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = children(get_app_env())

    opts = [strategy: :one_for_one, name: DocuSign.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children(:test), do: []

  defp children(_env) do
    [
      {DocuSign.ClientRegistry, []}
    ]
  end

  defp get_app_env do
    Application.fetch_env!(:docusign, :app_env)
  end
end
