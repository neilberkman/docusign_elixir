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

  defmodule Request do
    @moduledoc """
    Handle Tesla connections.
    """

    use Tesla
    plug(Tesla.Middleware.EncodeJson)

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
          Tesla.Middleware.EncodeJson,
          {Tesla.Middleware.Timeout, timeout: 5_000}
        ],
        Tesla.Adapter.Mint
      )
    end
  end

  @doc """
  Makes a request.
  """
  @spec request(t(), Keyword.t()) :: %OAuth2.Response{}
  def request(conn, opts \\ []) do
    {_, res} =
      conn
      |> Request.new()
      |> Request.request(opts)

    res
  end

  @doc """
  Create new conn

  opts:
  - client \\ APIClient.client()
  - account \\ User.default_account

  """
  @spec new(Keyword.t()) :: t()
  def new(opts \\ []) do
    with client <- Keyword.get(opts, :client, APIClient.client()),
         account <- Keyword.get(opts, :account, default_account()) do
      %__MODULE__{client: client, app_account: account}
    end
  end

  @doc """
  Retrieves the default account of current user
  """
  @spec default_account() :: User.AppAccount.t()
  def default_account, do: User.default_account(User.info())
end
