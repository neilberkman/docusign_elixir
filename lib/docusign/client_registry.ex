defmodule DocuSign.ClientRegistry do
  @moduledoc ~S"""
  GenServer to store API clients and automatically refresh JWT access tokens.

  The registry keeps track of API clients using the user ID (which is the API Username
  in the user's profile on DocuSign).
  """
  use GenServer
  alias DocuSign.OAuth

  defmodule State do
    defstruct clients: %{}, oauth_impl: nil
  end

  #####
  # External API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Get API Client
  """
  @type opts :: Keyword.t()
  @type user_id :: String.t()
  @spec client(user_id, opts) :: OAuth2.Client.t()
  def client(user_id, opts \\ []) do
    GenServer.call(__MODULE__, {:get_client, user_id, opts}, 10_000)
  end

  #####
  # GenServer implementation
  def init(_opts) do
    {:ok, %State{}}
  end

  def handle_call({:get_client, user_id, opts}, _from, state) do
    client =
      case Map.get(state.clients, user_id) do
        nil -> create_client(user_id, opts)
        {client, _opts} -> refresh_client(client, opts)
      end

    updated_clients = Map.put(state.clients, user_id, {client, opts})

    {:reply, client, %{state | clients: updated_clients}}
  end

  @doc """
  Async refreshes a token.
  """
  def handle_info({:refresh_token, user_id}, state) do
    {client, opts} = Map.get(state.clients, user_id)
    oauth_impl = Keyword.get(opts, :oauth_impl, oauth_implementation())
    new_client = oauth_impl.refresh_token!(client, true)
    updated_clients = Map.put(state.clients, user_id, {new_client, opts})

    delay = oauth_impl.interval_refresh_token(client)
    schedule_refresh_token(user_id, delay)

    {:noreply, %{state | clients: updated_clients}}
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

  defp oauth_implementation do
    Application.get_env(:docusign, :oauth_implementation, OAuth.Impl)
  end
end
