defmodule DocuSign.Debug do
  @moduledoc """
  Debugging and logging configuration for the DocuSign Elixir client.

  This module provides functionality to configure debug logging for HTTP requests and responses,
  similar to the Ruby DocuSign client's debugging capabilities.

  ## Configuration

  Enable debugging by setting the `:debugging` option in your application config:

      config :docusign, debugging: true

  You can also configure logging at runtime:

      DocuSign.Debug.enable_debugging()
      DocuSign.Debug.disable_debugging()

  ## Debug Logging

  When debugging is enabled, the client will log:
  - HTTP request method, URL, and headers
  - HTTP request body (with sensitive data filtered)
  - HTTP response status, headers, and body
  - Request/response timing information

  ## Header Filtering

  Sensitive headers like authorization tokens are automatically filtered in debug logs:

      config :docusign, :debug_filter_headers, ["authorization", "x-api-key"]

  ## Examples

      # Enable debugging for development
      config :docusign, debugging: true

      # Configure debug settings
      config :docusign,
        debugging: true,
        debug_filter_headers: ["authorization", "x-custom-secret"]

      # Or enable at runtime
      DocuSign.Debug.enable_debugging()
  """

  alias Tesla.Middleware.Headers
  alias Tesla.Middleware.Logger

  @default_filter_headers ["authorization"]

  @doc """
  Enable debugging for DocuSign HTTP requests.

  This will add Tesla.Middleware.Logger with debug options to all DocuSign connections.
  """
  @spec enable_debugging() :: :ok
  def enable_debugging do
    Application.put_env(:docusign, :debugging, true)
  end

  @doc """
  Disable debugging for DocuSign HTTP requests.
  """
  @spec disable_debugging() :: :ok
  def disable_debugging do
    Application.put_env(:docusign, :debugging, false)
  end

  @doc """
  Check if debugging is currently enabled.
  """
  @spec debugging_enabled?() :: boolean()
  def debugging_enabled? do
    Application.get_env(:docusign, :debugging, false)
  end

  @doc """
  Get the list of headers to filter in debug logs.

  Returns the configured filter headers or defaults to ["authorization"].
  """
  @spec filter_headers() :: [String.t()]
  def filter_headers do
    Application.get_env(:docusign, :debug_filter_headers, @default_filter_headers)
  end

  @doc """
  Build Tesla middleware for debugging based on current configuration.

  Returns a list of middleware to include in Tesla client configuration.
  If debugging is disabled, returns an empty list.
  """
  @spec middleware() :: list()
  def middleware do
    if debugging_enabled?() do
      [
        {Logger, debug: true, filter_headers: filter_headers(), format: "$method $url -> $status ($time ms)"}
      ]
    else
      []
    end
  end

  @doc """
  Build Tesla middleware for SDK identification headers.

  This adds the X-DocuSign-SDK header to identify the Elixir client,
  matching the Ruby client's behavior.
  """
  @spec sdk_headers() :: list()
  def sdk_headers do
    version = Application.spec(:docusign, :vsn) |> to_string()

    [
      {Headers,
       [
         {"X-DocuSign-SDK", "Elixir/#{version}"},
         {"User-Agent", "DocuSign-Elixir/#{version}"}
       ]}
    ]
  end

  @doc """
  Get all middleware for DocuSign connections including debugging and SDK headers.

  This is the main function used by the Connection module to build middleware.
  """
  @spec all_middleware() :: list()
  def all_middleware do
    sdk_headers() ++ middleware()
  end
end
