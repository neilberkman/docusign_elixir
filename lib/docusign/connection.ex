defmodule DocuSign.Connection do
  @moduledoc """
  The module is intended for to make and perform request to DocuSign API.

  ### Example

   iex> conn = DocuSign.Connection.new
   {:ok, users} = DocuSign.Api.Users.users_get_users(
     conn, "61ac4bd1-c83c-4aa6-8654-d3b44a252f42"[account_id]
   )
  """

  alias OAuth2.Request
  alias DocuSign.{APIClient, User}

  defstruct [:client, :app_account]

  @type t :: %__MODULE__{}

  @timeout 30_000

  defmodule Request do
    @moduledoc """
    Handle Tesla connections.
    """

    use Tesla
    plug(Tesla.Middleware.EncodeJson, engine: Poison)

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
          {Tesla.Middleware.EncodeJson, engine: Poison}
        ],
        Tesla.Adapter.Mint
      )
    end
  end

  @doc """
  Create new conn for given user ID, or for default configured user ID if not provided.
  """
  @spec new(String.t(), Keyword.t()) :: t()
  def new(user_id \\ nil, opts \\ [])

  def new(user_id, _opts) when is_nil(user_id) do
    client = get_default_client()
    account = get_default_account_for_client(client)

    __MODULE__
    |> struct(
      client: client,
      app_account: account
    )
  end

  def new(user_id, opts) do
    client = APIClient.client(user_id, opts)
    account = get_default_account_for_client(client)

    __MODULE__
    |> struct(
      client: client,
      app_account: account
    )
  end

  defp get_default_client do
    APIClient.client()
  end

  defp get_default_account_for_client(client) do
    client
    |> User.info()
    |> User.default_account()
  end

  @doc """
  Makes a request.
  """
  @spec request(t(), Keyword.t()) :: %OAuth2.Response{}
  def request(conn, opts \\ []) do
    timeout = Application.get_env(:docusign, :timeout, @timeout)
    opts = opts |> Keyword.merge(opts: [adapter: [timeout: timeout]])

    {_, res} =
      conn
      |> Request.new()
      |> Request.request(opts)

    res
  end

  @doc """
  Retrieves the default account of default user configured
  """
  @spec default_account() :: User.AppAccount.t()
  def default_account() do
    get_default_client()
    |> get_default_account_for_client()
  end
end
