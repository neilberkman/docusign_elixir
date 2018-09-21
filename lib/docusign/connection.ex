defmodule DocuSign.Connection do
  alias OAuth2.{Client, Request}
  alias DocuSign.{APIClient, Util, User}

  defstruct [:client, :app_account]

  def request(conn, opts \\ []) do
    with method <- Keyword.get(opts, :method),
         path <- Keyword.get(opts, :url),
         url <- build_url(conn.app_account, path) do
      {:ok, resp} = Request.request(method, conn.client, url, %{}, [], [])
      resp
    end
  end

  @doc """
  Create new conn
  """
  def new(opts \\ []) do
    with client <- Keyword.get(opts, :client, APIClient.client()),
         account <- Keyword.get(opts, :account, default_account) do
      %__MODULE__{client: client, app_account: account}
    end
  end

  def build_url(app_account, path), do: "#{app_account.base_uri}/restapi/#{path}"
  def default_account, do: User.default_account(User.info())
end
