defmodule DocuSign.Debug do
  @moduledoc """
  Debugging and logging configuration for the DocuSign Elixir client.

  Configure debug logging for HTTP requests and responses.

  ## Configuration

  Enable debugging by setting the `:debug` option in your application config:

      config :docusign, debug: true

  You can also configure logging at runtime before creating a connection:

      DocuSign.Debug.enable_debugging()
      DocuSign.Debug.disable_debugging()

  The `:debug` setting determines whether debug steps are added when a connection
  is created. Changing it does not update existing connections. Messages use the
  `:debug` log level; configure Logger to allow that level to see them.

  ## Debug Logging

  With `debug: true`, the client logs the request method and URL, response status,
  and filtered request and response headers. Bodies are omitted by default.

  Set `debug_body: true` in application configuration to log bodies:

      config :docusign, debug: true, debug_body: true

  Bodies are logged verbatim, without filtering. They can contain signer names,
  emails, and document content. Do not enable `debug_body` in production.

  A direct `DocuSign.Connection.request/2` call can override body and header logging:

      DocuSign.Connection.request(conn,
        method: :get,
        url: "/accounts",
        debug_body: true,
        debug_headers: false
      )

  These per-request options require a connection created with debugging enabled.
  `debug_body` defaults to the application setting, or `false`. `debug_headers`
  defaults to `true`; setting it to `false` omits headers while keeping the method,
  URL, and status. Generated API functions do not forward these options.

  ## Header Filtering

  The `authorization` header is filtered by default. In both request and response
  logs, each header whose name matches the filter list has its entire value
  replaced with `"[FILTERED]"`. Header names are kept and compared case-insensitively.

  This configuration replaces the default list; keep `"authorization"` to continue
  filtering bearer tokens:

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

  Connections created after this call include debug steps.
  """
  @spec enable_debugging() :: :ok
  def enable_debugging do
    Application.put_env(:docusign, :debug, true)
  end

  @doc """
  Disable debugging for DocuSign HTTP requests.

  Connections created after this call omit debug steps.
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
