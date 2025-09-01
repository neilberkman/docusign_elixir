defmodule DocuSign.Connection do
  @moduledoc """
  The module is intended to be used to establish a connection with
  DocuSign eSignature API and then perform requests to it.

  ## JWT Impersonation Example

      iex> user_id = "74830914-547328-5432-5432543"
      iex> account_id = "61ac4bd1-c83c-4aa6-8654-ddf3tg5"
      iex> {:ok, conn} = DocuSign.Connection.get(user_id)
      iex> {:ok, users} = DocuSign.Api.Users.users_get_users(conn, account_id)
      {:ok, %DocuSign.Model.UserInformationList{...}}

  ## OAuth2 Authorization Code Flow Example

      # Using the OAuth2 Authorization Code Strategy
      iex> oauth_client = DocuSign.OAuth.AuthorizationCodeStrategy.client(
      ...>   redirect_uri: "https://yourapp.com/auth/callback"
      ...> )
      ...> |> DocuSign.OAuth.AuthorizationCodeStrategy.get_token!(code: "auth_code")
      iex> user_info = DocuSign.OAuth.AuthorizationCodeStrategy.get_user_info!(oauth_client)
      iex> account = Enum.find(user_info["accounts"], &(&1["is_default"] == "true"))
      iex> {:ok, conn} = DocuSign.Connection.from_oauth_client(
      ...>   oauth_client,
      ...>   account_id: account["account_id"],
      ...>   base_uri: account["base_uri"] <> "/restapi"
      ...> )
      iex> {:ok, users} = DocuSign.Api.Users.users_get_users(conn, account["account_id"])
      {:ok, %DocuSign.Model.UserInformationList{...}}
  """

  alias DocuSign.Util.Environment
  alias DocuSign.{ClientRegistry, Debug, Error, User}

  defstruct [:app_account, :client, :req]

  @type t :: %__MODULE__{
          app_account: map() | nil,
          client: OAuth2.Client.t() | nil,
          req: Req.Request.t()
        }

  @timeout 30_000

  @doc """
  Create new connection for provided user ID using JWT impersonation.
  """
  @type oauth_error :: OAuth2.Response.t() | OAuth2.Error.t()
  @spec get(String.t()) :: {:ok, t()} | {:error, oauth_error}
  def get(user_id) do
    case ClientRegistry.client(user_id) do
      {:ok, client} ->
        account = get_default_account_for_client(client)

        # Auto-detect hostname from account base_uri if not already configured
        if is_nil(Application.get_env(:docusign, :hostname)) do
          hostname = Environment.determine_hostname(account.base_uri)
          Application.put_env(:docusign, :hostname, hostname)
        end

        connection = build_connection(client, account)
        {:ok, connection}

      {:error, error} ->
        if consent_required_error?(error) do
          url = build_consent_url()
          message = "Ask user to visit this URL to consent impersonation: #{url}"
          {:error, {:consent_required, message}}
        else
          {:error, error}
        end
    end
  end

  @doc """
  Create new connection from OAuth2 client with tokens.

  This function creates a connection using an OAuth2.Client obtained through the
  authorization code flow with `DocuSign.OAuth.AuthorizationCodeStrategy`.

  ## Parameters

  - `oauth_client` - OAuth2.Client with valid access token
  - `opts` - Keyword list of options:
    - `:account_id` - DocuSign account ID (required)
    - `:base_uri` - API base URI (required)

  ## Examples

      # Using OAuth2 Authorization Code Strategy
      oauth_client = DocuSign.OAuth.AuthorizationCodeStrategy.client(
        redirect_uri: "https://yourapp.com/callback"
      )
      |> DocuSign.OAuth.AuthorizationCodeStrategy.get_token!(code: auth_code)

      # Get user info to find account details
      user_info = DocuSign.OAuth.AuthorizationCodeStrategy.get_user_info!(oauth_client)
      account = Enum.find(user_info["accounts"], &(&1["is_default"] == "true"))

      # Create connection
      {:ok, conn} = from_oauth_client(
        oauth_client,
        account_id: account["account_id"],
        base_uri: account["base_uri"] <> "/restapi"
      )

  ## Returns

  - `{:ok, connection}` - Success with connection struct
  - `{:error, reason}` - Failure with error reason

  ## Notes

  - The `base_uri` should be the full API endpoint (e.g., "https://demo.docusign.net/restapi")
  - Use the account information from the user info endpoint to get correct base_uri
  - The connection can be used immediately with DocuSign API functions
  """
  @spec from_oauth_client(OAuth2.Client.t(), keyword()) :: {:ok, t()} | {:error, atom()}
  def from_oauth_client(%OAuth2.Client{} = oauth_client, opts \\ []) do
    with {:ok, account_id} <- fetch_required_opt(opts, :account_id),
         {:ok, base_uri} <- fetch_required_opt(opts, :base_uri) do
      app_account = %{
        account_id: account_id,
        base_uri: base_uri
      }

      connection = build_connection(oauth_client, app_account)
      {:ok, connection}
    end
  end

  defp fetch_required_opt(opts, key) do
    case Keyword.fetch(opts, key) do
      {:ok, value} -> {:ok, value}
      :error -> {:error, {:missing_required_option, key}}
    end
  end

  defp consent_required_error?(error) do
    reason = Map.get(error, :reason)
    is_binary(reason) && reason =~ "consent_required"
  end

  defp build_consent_url do
    client_id = Application.fetch_env!(:docusign, :client_id)
    hostname = Application.fetch_env!(:docusign, :hostname)

    "https://#{hostname}/oauth/auth?response_type=code&scope=signature%20impersonation&client_id=#{client_id}&redirect_uri=https://#{hostname}/me"
  end

  defp get_default_account_for_client(client) do
    client
    |> User.info()
    |> User.default_account()
    |> add_base_uri_to_account()
  end

  defp add_base_uri_to_account(account) do
    %{account | base_uri: "#{account.base_uri}/restapi"}
  end

  defp build_connection(client, app_account) do
    # Get token from either OAuth2.Client or JWT client
    token =
      case client do
        %OAuth2.Client{token: %OAuth2.AccessToken{} = token} ->
          token

        %{token: token} when not is_nil(token) ->
          token

        _ ->
          # Handle case where token might be nil
          %{access_token: "", token_type: "Bearer"}
      end

    # Build Req client with base configuration
    req =
      Req.new(
        base_url: app_account.base_uri,
        headers:
          [
            {"authorization", "#{token.token_type} #{token.access_token}"},
            {"content-type", "application/json"}
          ] ++ Debug.sdk_headers(),
        receive_timeout: Application.get_env(:docusign, :timeout, @timeout)
      )
      |> configure_retry()
      |> maybe_add_debug_steps()

    %__MODULE__{
      app_account: app_account,
      client: client,
      req: req
    }
  end

  defp configure_retry(req) do
    retry_options = Application.get_env(:docusign, :retry_options, [])

    if retry_options[:enabled] == false do
      # Explicitly disabled
      Req.merge(req, retry: false)
    else
      # Configure retry with defaults and user options
      max_retries = retry_options[:max_retries] || 3
      backoff_factor = retry_options[:backoff_factor] || 2
      max_delay = retry_options[:max_delay] || 30_000

      req
      |> Req.merge(
        retry: :transient,
        max_retries: max_retries,
        retry_delay: &calculate_retry_delay(&1, backoff_factor, max_delay)
      )
      |> Req.Request.prepend_error_steps(handle_rate_limit: &handle_rate_limit_error/1)
    end
  end

  defp calculate_retry_delay(attempt, backoff_factor, max_delay) do
    # Exponential backoff with jitter
    # Ensure non-negative exponent (attempt starts from 0 in Req)
    exponent = max(0, attempt)
    base_delay = Integer.pow(backoff_factor, exponent) * 1000
    jittered = base_delay + :rand.uniform(1000)
    min(jittered, max_delay)
  end

  defp handle_rate_limit_error({request, %Req.Response{status: 429} = response}) do
    # Check for Retry-After header
    retry_after = get_retry_after(response.headers)

    # Emit telemetry event for rate limit
    if retry_after do
      # Try to get metadata from finch_private or use defaults
      finch_private = request.options[:finch_private] || %{}

      metadata = %{
        account_id: finch_private[:account_id] || "unknown",
        operation: finch_private[:operation] || "unknown"
      }

      DocuSign.Telemetry.execute_rate_limit(metadata.operation, retry_after, metadata)
    end

    if retry_after && request.private[:retry_count] < request.options[:max_retries] do
      # Wait for the specified time before retrying
      Process.sleep(retry_after * 1000)
      {request, {:retry, response}}
    else
      {request, response}
    end
  end

  defp handle_rate_limit_error({request, response_or_error}) do
    {request, response_or_error}
  end

  defp get_retry_after(headers) do
    case List.keyfind(headers, "retry-after", 0) do
      {"retry-after", value} when is_list(value) ->
        value |> List.first() |> parse_retry_after()

      {"retry-after", value} when is_binary(value) ->
        parse_retry_after(value)

      _ ->
        nil
    end
  end

  defp parse_retry_after(value) when is_binary(value) do
    case Integer.parse(value) do
      {seconds, ""} -> seconds
      _ -> nil
    end
  end

  defp parse_retry_after(_), do: nil

  defp maybe_add_debug_steps(req) do
    if Application.get_env(:docusign, :debug, false) do
      req
      |> Req.Request.register_options([:debug_body, :debug_headers])
      |> Req.Request.prepend_request_steps(debug_request: &debug_request/1)
      |> Req.Request.prepend_response_steps(debug_response: &debug_response/1)
    else
      req
    end
  end

  defp debug_request(request) do
    if request.options[:debug_headers] do
      require Logger

      Logger.debug("Request Headers: #{inspect(request.headers)}")
    end

    if request.options[:debug_body] do
      require Logger

      Logger.debug("Request Body: #{inspect(request.body)}")
    end

    request
  end

  defp debug_response({request, response}) do
    if request.options[:debug_headers] do
      require Logger

      Logger.debug("Response Headers: #{inspect(response.headers)}")
    end

    if request.options[:debug_body] do
      require Logger

      Logger.debug("Response Body: #{inspect(response.body)}")
    end

    {request, response}
  end

  @doc """
  Makes a request.

  ## Options

  * `:ssl_options` - Override SSL options for this specific request
  * `:telemetry_metadata` - Additional metadata to include in telemetry events
  * All other options are passed through to Req

  ## Examples

      # Use custom CA certificate for this request
      DocuSign.Connection.request(conn,
        method: :get,
        url: "/accounts",
        ssl_options: [cacertfile: "/custom/ca.pem"]
      )

      # With telemetry metadata
      DocuSign.Connection.request(conn,
        method: :get,
        url: "/accounts",
        telemetry_metadata: %{operation: "list_accounts"}
      )
  """
  @spec request(t(), Keyword.t()) :: {:ok, Req.Response.t()} | {:error, any()}
  def request(%__MODULE__{app_account: app_account, req: req}, opts \\ []) do
    {ssl_opts, opts, telemetry_meta} = extract_options(opts)
    {operation, metadata, start_time} = setup_telemetry(app_account, opts, telemetry_meta)

    req = apply_ssl_options(req, ssl_opts)
    opts = add_telemetry_to_opts(opts, operation, app_account)

    execute_request_with_telemetry(req, opts, operation, metadata, start_time)
  end

  # Extract SSL and telemetry options from opts
  defp extract_options(opts) do
    {ssl_opts, opts} = Keyword.pop(opts, :ssl_options, [])
    {telemetry_meta, opts} = Keyword.pop(opts, :telemetry_metadata, %{})
    {ssl_opts, opts, telemetry_meta}
  end

  # Setup telemetry metadata and start timing
  defp setup_telemetry(app_account, opts, telemetry_meta) do
    method = opts[:method] || :get
    path = opts[:url] || "/"
    operation = telemetry_meta[:operation] || extract_operation_name(method, path)

    account_id =
      case app_account do
        %{account_id: id} -> id
        _ -> nil
      end

    metadata =
      Map.merge(telemetry_meta, %{
        account_id: account_id,
        method: method,
        path: path
      })

    start_time = System.monotonic_time()
    DocuSign.Telemetry.execute_api_start(operation, metadata)

    {operation, metadata, start_time}
  end

  # Apply SSL options to req if provided
  defp apply_ssl_options(req, []), do: req

  defp apply_ssl_options(req, ssl_opts) do
    transport_opts =
      if Code.ensure_loaded?(DocuSign.SSLOptions) do
        DocuSign.SSLOptions.build(ssl_opts)
      else
        ssl_opts
      end

    Req.merge(req, connect_options: [transport_opts: transport_opts])
  end

  # Add telemetry metadata to Finch private options for correlation
  defp add_telemetry_to_opts(opts, operation, app_account) do
    account_id =
      case app_account do
        %{account_id: id} -> id
        _ -> nil
      end

    Keyword.update(opts, :finch_private, %{operation: operation}, fn existing ->
      Map.merge(existing, %{account_id: account_id, operation: operation})
    end)
  end

  # Execute the request with proper telemetry handling
  defp execute_request_with_telemetry(req, opts, operation, metadata, start_time) do
    handle_request_response(Req.request(req, opts), operation, metadata, start_time)
  rescue
    exception ->
      DocuSign.Telemetry.execute_api_exception(
        operation,
        start_time,
        :error,
        exception,
        __STACKTRACE__,
        metadata
      )

      reraise exception, __STACKTRACE__
  end

  # Handle the various response cases
  defp handle_request_response({:ok, %Req.Response{status: status} = response}, operation, metadata, start_time)
       when status in 200..299 do
    stop_metadata = Map.put(metadata, :status, status)
    DocuSign.Telemetry.execute_api_stop(operation, start_time, stop_metadata)
    {:ok, response}
  end

  defp handle_request_response({:ok, %Req.Response{status: status} = response}, operation, metadata, start_time) do
    stop_metadata = Map.put(metadata, :status, status)
    DocuSign.Telemetry.execute_api_stop(operation, start_time, stop_metadata)
    handle_error_response(response)
  end

  defp handle_request_response({:error, reason} = error, operation, metadata, start_time) do
    DocuSign.Telemetry.execute_api_exception(
      operation,
      start_time,
      :error,
      reason,
      [],
      metadata
    )

    error
  end

  defp extract_operation_name(method, path) do
    # Extract a meaningful operation name from the path
    # e.g., "/v2.1/accounts/123/envelopes" -> "envelopes"
    # e.g., "/v2.1/accounts/123/envelopes/456" -> "envelope"
    path
    |> String.split("/")
    |> Enum.reject(&(&1 == "" or String.starts_with?(&1, "v")))
    |> List.last()
    |> case do
      nil -> "unknown"
      name -> "#{method}_#{name}" |> String.downcase()
    end
  end

  defp handle_error_response(response) do
    if Application.get_env(:docusign, :structured_errors, false) do
      {:error, Error.new(response)}
    else
      {:error, {:http_error, response.status, response.body}}
    end
  end

  @doc """
  Downloads a file from the DocuSign API.

  This is a convenience function that wraps `DocuSign.FileDownloader.download/3`.
  It provides an easy way to download documents, attachments, and other files
  from DocuSign APIs with automatic filename extraction and flexible storage options.

  ## Options

  See `DocuSign.FileDownloader.download/3` for all available options.

  ## Examples

      # Download envelope document to temporary file
      {:ok, temp_path} = DocuSign.Connection.download_file(conn,
        "/v2.1/accounts/123/envelopes/456/documents/1")

      # Download to memory
      {:ok, {content, filename, content_type}} = DocuSign.Connection.download_file(conn, url,
        strategy: :memory)

      # Download with custom temp options
      {:ok, path} = DocuSign.Connection.download_file(conn, url,
        temp_options: [prefix: "contract", suffix: ".pdf"])

  """
  @spec download_file(t(), String.t(), DocuSign.FileDownloader.download_options()) ::
          DocuSign.FileDownloader.download_result()
  def download_file(conn, url, opts \\ []) do
    DocuSign.FileDownloader.download(conn, url, opts)
  end

  @doc """
  Automatically determines the appropriate OAuth hostname based on a base URI.

  This function provides a convenient way to automatically configure the correct
  OAuth hostname by analyzing the provided base URI for sandbox/demo patterns.
  This is useful when creating connections with different environments.

  ## Parameters

  - `base_uri` - The DocuSign API base URI (e.g., "https://demo.docusign.net/restapi")

  ## Returns

  - `"account-d.docusign.com"` for sandbox/demo environments
  - `"account.docusign.com"` for production environments

  ## Examples

      # Automatically detect sandbox environment
      iex> DocuSign.Connection.determine_hostname("https://demo.docusign.net/restapi")
      "account-d.docusign.com"

      # Automatically detect production environment
      iex> DocuSign.Connection.determine_hostname("https://na3.docusign.net/restapi")
      "account.docusign.com"

  ## Usage with OAuth2 Configuration

      # Use automatic detection for OAuth2 setup
      base_uri = "https://demo.docusign.net/restapi"
      hostname = DocuSign.Connection.determine_hostname(base_uri)

      Application.put_env(:docusign, :hostname, hostname)

  """
  @spec determine_hostname(String.t()) :: String.t()
  def determine_hostname(base_uri) when is_binary(base_uri) do
    Environment.determine_hostname(base_uri)
  end

  @doc """
  Detects the environment type based on the API base URI.

  ## Parameters

  - `base_uri` - The DocuSign API base URI

  ## Returns

  - `:sandbox` for sandbox/demo environments
  - `:production` for production environments

  ## Examples

      iex> DocuSign.Connection.detect_environment("https://demo.docusign.net")
      :sandbox

      iex> DocuSign.Connection.detect_environment("https://na3.docusign.net")
      :production

  """
  @spec detect_environment(String.t()) :: :sandbox | :production
  def detect_environment(base_uri) when is_binary(base_uri) do
    Environment.detect_environment(base_uri)
  end

  @doc """
  Creates a connection with automatic environment detection from OAuth client.

  This is an enhanced version of `from_oauth_client/2` that can automatically
  determine the OAuth hostname from the base_uri if not already configured.

  ## Parameters

  - `oauth_client` - The OAuth2.Client with valid tokens
  - `opts` - Options including:
    - `:account_id` (required) - The DocuSign account ID
    - `:base_uri` (required) - The API base URI
    - `:auto_detect_hostname` (optional) - Whether to automatically set hostname config

  ## Options

  - `:auto_detect_hostname` - If `true`, automatically configures the application
    hostname based on the base_uri environment detection. Default: `false`

  ## Examples

      # Create connection with automatic hostname detection
      {:ok, conn} = DocuSign.Connection.from_oauth_client_with_detection(
        oauth_client,
        account_id: "12345",
        base_uri: "https://demo.docusign.net/restapi",
        auto_detect_hostname: true
      )

  """
  @spec from_oauth_client_with_detection(OAuth2.Client.t(), keyword()) ::
          {:ok, t()} | {:error, atom()}
  def from_oauth_client_with_detection(%OAuth2.Client{} = oauth_client, opts \\ []) do
    {auto_detect, opts} = Keyword.pop(opts, :auto_detect_hostname, false)

    if auto_detect do
      case Keyword.fetch(opts, :base_uri) do
        {:ok, base_uri} ->
          hostname = Environment.determine_hostname(base_uri)
          Application.put_env(:docusign, :hostname, hostname)

        :error ->
          # No base_uri provided, skip auto-detection
          :ok
      end
    end

    from_oauth_client(oauth_client, opts)
  end
end
