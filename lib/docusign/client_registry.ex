defmodule DocuSign.ClientRegistry do
  @moduledoc ~S"""
  GenServer to store API client and refresh access token by schedule.
  """
  use GenServer
  alias DocuSign.OAuth

  #####
  # External API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Get Api Client
  """
  @type opts :: Keyword.t()
  @type user_id_or_opts :: String.t() | opts
  @spec client(user_id_or_opts, opts) :: OAuth2.Client.t()
  def client(user_id \\ [], opts \\ [])

  def client(opts, _) when is_list(opts) do
    user_id = Keyword.get(opts, :user_id, default_user_id())
    client(user_id, opts)
  end

  def client(user_id, opts) when is_binary(user_id) do
    GenServer.call(__MODULE__, {:get_client, user_id, opts}, 10_000)
  end

  #####
  # GenServer implementation
  def init(_opts) do
    {:ok, %{}}
  end

  def handle_call({:get_client, user_id, opts}, _from, clients) do
    client =
      case Map.get(clients, user_id) do
        nil -> create_client(user_id, opts)
        {client, _opts} -> refresh_client(client, opts)
      end

    updated_registry = Map.put(clients, user_id, {client, opts})

    {:reply, client, updated_registry}
  end

  @doc """
  Async refreshes a token.
  """
  def handle_info({:refresh_token, user_id}, clients) do
    {client, opts} = Map.get(clients, user_id)
    oauth_impl = Keyword.get(opts, :oauth_impl, oauth_implementation())
    new_client = oauth_impl.refresh_token!(client, true)
    updated_registry = Map.put(clients, user_id, {new_client, opts})

    delay = oauth_impl.interval_refresh_token(client)
    schedule_refresh_token(user_id, delay)

    {:noreply, updated_registry}
  end

  defp create_client(user_id, opts) do
    oauth_impl = Keyword.get(opts, :oauth_impl, oauth_implementation())
    client = oauth_impl.refresh_token!(oauth_impl.client(user_id: user_id), true)
    delay = oauth_impl.interval_refresh_token(client)
    schedule_refresh_token(user_id, delay)
    client
  end

  defp refresh_client(client, opts) do
    oauth_impl = Keyword.get(opts, :oauth_impl, oauth_implementation())
    oauth_impl.refresh_token!(client)
  end

  defp schedule_refresh_token(user_id, seconds) do
    Process.send_after(self(), {:refresh_token, user_id}, seconds * 1000)
  end

  defp default_user_id do
    Application.fetch_env!(:docusign, :user_id)
  end

  defp oauth_implementation do
    Application.get_env(:docusign, :oauth_implementation, OAuth.Impl)
  end
end
