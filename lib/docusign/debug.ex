defmodule DocuSign.Debug do
  @moduledoc """
  Debugging and logging configuration for the DocuSign Elixir client.

  This module provides functionality to configure debug logging for HTTP requests and responses,
  similar to the Ruby DocuSign client's debugging capabilities.

  ## Configuration

  Enable debugging by setting the `:debug` option in your application config:

      config :docusign, debug: true

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
      config :docusign, debug: true

      # Configure debug settings
      config :docusign,
        debug: true,
        debug_filter_headers: ["authorization", "x-custom-secret"]

      # Or enable at runtime
      DocuSign.Debug.enable_debugging()
  """

  @default_filter_headers ["authorization"]

  @doc """
  Enable debugging for DocuSign HTTP requests.

  This will enable debug logging for all DocuSign connections.
  """
  @spec enable_debugging() :: :ok
  def enable_debugging do
    Application.put_env(:docusign, :debug, true)
  end

  @doc """
  Disable debugging for DocuSign HTTP requests.
  """
  @spec disable_debugging() :: :ok
  def disable_debugging do
    Application.put_env(:docusign, :debug, false)
  end

  @doc """
  Check if debugging is currently enabled.
  """
  @spec debugging_enabled?() :: boolean()
  def debugging_enabled? do
    Application.get_env(:docusign, :debug, false)
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
  Get SDK headers for identifying the Elixir client.

  This adds the X-DocuSign-SDK header to identify the Elixir client,
  matching the Ruby client's behavior.
  """
  @spec sdk_headers() :: [{String.t(), String.t()}]
  def sdk_headers do
    user_agent = DocuSign.SDKVersion.user_agent()
    sdk_version = DocuSign.SDKVersion.version()

    [
      {"X-DocuSign-SDK", "Elixir/#{sdk_version}"},
      {"User-Agent", user_agent}
    ]
  end

  @doc """
  Get all middleware for DocuSign connections including debugging and SDK headers.

  Note: This function is now deprecated as Req handles middleware differently.
  Use sdk_headers() directly if needed.
  """
  @spec all_middleware() :: list()
  @deprecated "Use sdk_headers() directly with Req configuration"
  def all_middleware do
    []
  end

  @doc """
  Build middleware for debugging based on current configuration.

  Note: This function is now deprecated as Req handles middleware differently.
  """
  @spec middleware() :: list()
  @deprecated "Use sdk_headers() directly with Req configuration"
  def middleware do
    []
  end
end
