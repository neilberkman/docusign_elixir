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

  alias DocuSign.{ClientRegistry, User}
  alias OAuth2.Request
  alias Tesla.Adapter.Finch
  alias Tesla.Middleware.BaseUrl
  alias Tesla.Middleware.EncodeJson
  alias Tesla.Middleware.Headers

  defstruct [:app_account, :client]

  @type t :: %__MODULE__{
          app_account: map() | nil,
          client: OAuth2.Client.t() | nil
        }

  @timeout 30_000

  defmodule Request do
    @moduledoc """
    Handle Tesla connections.
    """

    @doc """
    Configure a client connection for both JWT impersonation and OAuth2 tokens.

    This function pattern matches on the connection struct to determine whether
    to use JWT tokens (from ClientRegistry) or OAuth2 tokens (from authorization code flow).

    # Returns

    Tesla.Env.client
    """
    @spec new(%{app_account: map(), client: OAuth2.Client.t()}) :: Tesla.Env.client()
    def new(%{app_account: app, client: %OAuth2.Client{token: %OAuth2.AccessToken{} = token}}) do
      # OAuth2.Client from authorization code flow
      Tesla.client(
        [
          {BaseUrl, app.base_uri},
          {Headers, [{"authorization", "#{token.token_type} #{token.access_token}"}]},
          {EncodeJson, engine: Jason}
        ],
        Application.get_env(:tesla, :adapter, {Finch, name: DocuSign.Finch})
      )
    end

    def new(%{app_account: app, client: %{token: token}}) do
      # JWT impersonation client
      Tesla.client(
        [
          {BaseUrl, app.base_uri},
          {Headers, [{"authorization", "#{token.token_type} #{token.access_token}"}]},
          {EncodeJson, engine: Jason}
        ],
        Application.get_env(:tesla, :adapter, {Finch, name: DocuSign.Finch})
      )
    end
  end

  @doc """
  Create new connection for provided user ID using JWT impersonation.
  """
  @type oauth_error :: OAuth2.Response.t() | OAuth2.Error.t()
  @spec get(String.t()) :: {:ok, t()} | {:error, oauth_error}
  def get(user_id) do
    case ClientRegistry.client(user_id) do
      {:ok, client} ->
        account = get_default_account_for_client(client)
        connection = struct(__MODULE__, client: client, app_account: account)
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

      connection = %__MODULE__{
        app_account: app_account,
        client: oauth_client
      }

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

  @doc """
  Makes a request.

  ## Options

  * `:ssl_options` - Override SSL options for this specific request
  * All other options are passed through to Tesla

  ## Examples

      # Use custom CA certificate for this request
      DocuSign.Connection.request(conn,
        method: :get,
        url: "/accounts",
        ssl_options: [cacertfile: "/custom/ca.pem"]
      )
  """
  @spec request(t(), Keyword.t()) :: {:ok, Tesla.Env.t()} | {:error, any()}
  def request(conn, opts \\ []) do
    timeout = Application.get_env(:docusign, :timeout, @timeout)

    # Extract SSL options if provided
    {ssl_opts, opts} = Keyword.pop(opts, :ssl_options, [])

    # Build adapter options with SSL configuration
    adapter_opts = build_adapter_options(timeout, ssl_opts)

    # Use the original format with nested adapter key
    opts = Keyword.put(opts, :opts, adapter: adapter_opts)

    result =
      conn
      |> Request.new()
      |> Tesla.request(opts)

    case result do
      {status, res} when status in [:ok, :error] -> {status, res}
      # When Tesla returns just the env without a tuple
      res -> {:ok, res}
    end
  end

  defp build_adapter_options(timeout, ssl_opts) do
    base_opts = [receive_timeout: timeout]

    if ssl_opts == [] do
      base_opts
      # Merge with default SSL options
    else
      transport_opts =
        if Code.ensure_loaded?(DocuSign.SSLOptions) do
          DocuSign.SSLOptions.build(ssl_opts)
        else
          ssl_opts
        end

      Keyword.put(base_opts, :transport_opts, transport_opts)
    end
  end
end
