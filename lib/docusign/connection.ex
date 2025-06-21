defmodule DocuSign.Connection do
  @moduledoc """
  The module is intended to be used to establish a connection with
  DocuSign eSignature API and then perform requests to it.

  ### Example

      iex> user_id = "74830914-547328-5432-5432543"
      iex> account_id = "61ac4bd1-c83c-4aa6-8654-ddf3tg5"
      iex> {:ok, conn} = DocuSign.Connection.get(user_id)
      iex> {:ok, users} = DocuSign.Api.Users.users_get_users(conn, account_id)
      {:ok, %DocuSign.Model.UserInformationList{...}}
  """

  alias OAuth2.Request
  alias DocuSign.{ClientRegistry, User}

  defstruct [:client, :app_account]

  @type t :: %__MODULE__{}

  @timeout 30_000

  defmodule Request do
    @moduledoc """
    Handle Tesla connections.
    """

    @doc """
    Configure an authless client connection

    # Returns

    Tesla.Env.client
    """
    @spec new(DocuSign.Connection.t()) :: Tesla.Env.client()
    def new(%{client: %{token: token} = _client, app_account: app} = _conn) do
      Tesla.client(
        [
          {Tesla.Middleware.BaseUrl, app.base_uri},
          {Tesla.Middleware.Headers,
           [{"authorization", "#{token.token_type} #{token.access_token}"}]},
          {Tesla.Middleware.EncodeJson, engine: Jason}
        ],
        Application.get_env(:docusign, :adapter, Tesla.Adapter.Mint)
      )
    end
  end

  @doc """
  Create new conn for provided user ID.
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

  defp consent_required_error?(error) do
    reason = Map.get(error, :reason)
    is_binary(reason) && reason =~ "consent_required"
  end

  defp build_consent_url() do
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
  """
  @spec request(t(), Keyword.t()) :: {:ok, Tesla.Env.t()} | {:error, Tesla.Env.t()}
  def request(conn, opts \\ []) do
    timeout = Application.get_env(:docusign, :timeout, @timeout)
    opts = opts |> Keyword.merge(opts: [adapter: [timeout: timeout]])

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
end
