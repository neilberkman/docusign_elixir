defmodule DocuSign.Connection do
  @moduledoc """
  The module is intended to be used to establish a connection with
  DocuSign eSignature API and then perform requests to it.

  ### Example

      iex> user_id = "74830914-547328-5432-5432543"
      iex> account_id = "61ac4bd1-c83c-4aa6-8654-ddf3tg5"
      iex> conn = DocuSign.Connection.get(user_id)
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
  Create new conn for default configured user ID
  """
  @deprecated "Use DocuSign.Connection.get/1 instead."
  @spec new() :: t()
  def new() do
    client = get_default_client()
    account = get_default_account_for_client(client)

    __MODULE__
    |> struct(
      client: client,
      app_account: account
    )
  end

  # Note: to delete once all deprecated functions have been removed.
  defp get_default_client do
    ClientRegistry.client(default_user_id())
  end

  # Note: to delete once all deprecated functions have been removed.
  defp default_user_id do
    Application.get_env(:docusign, :user_id)
  end

  @doc """
  Create new conn for provided user ID.
  """
  @spec get(String.t()) :: t()
  def get(user_id) do
    client = ClientRegistry.client(user_id)
    account = get_default_account_for_client(client)

    __MODULE__
    |> struct(
      client: client,
      app_account: account
    )
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
  @deprecated """
  Please use `Docusign.Connection.get/1`. The returned structs includes `app_account`, which is the default account.
  """
  def default_account() do
    get_default_client()
    |> get_default_account_for_client()
  end
end
