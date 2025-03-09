defmodule DocuSign.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    # Configure OAuth2 to use Jason as json library
    if Code.ensure_loaded?(Jason) do
      Application.put_env(:oauth2, :json_library, Jason)
    end

    # Apply runtime patches before starting the application
    apply_runtime_patches()

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
    Application.get_env(:docusign, :app_env, :prod)
  end

  @doc false
  def apply_runtime_patches do
    # The RequestBuilder now directly uses ModelCleaner
    if Code.ensure_loaded?(DocuSign.ModelCleaner) do
      Logger.info(
        "✅ DocuSign: ModelCleaner integrated into RequestBuilder to fix INVALID_REQUEST_BODY errors"
      )
    else
      Logger.warning(
        "⚠️ DocuSign: ModelCleaner module not available, this may cause issues with API requests"
      )
    end
  end
end
