defmodule DocuSign.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @client_id Application.get_env(:docusign, :client_id)
  @user_id Application.get_env(:docusign, :user_id)

  def start(_type, _args) do
    children = [
      {DocuSign.APIClient, {@client_id, @user_id}}
    ]

    opts = [strategy: :one_for_one, name: DocuSign.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
