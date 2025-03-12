defmodule DocuSign.ClientRegistry do
  @moduledoc ~S"""
  GenServer to store API clients and automatically refresh JWT access tokens.

  The registry keeps track of API clients using the user ID (which is the API Username
  in the user's profile on DocuSign).
  """
  use GenServer

  defmodule State do
    @moduledoc false
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
  @type user_id :: String.t()
  @type oauth_error :: OAuth2.Response.t() | OAuth2.Error.t()
  @spec client(user_id) :: {:ok, OAuth2.Client.t()} | {:error, oauth_error}
  def client(user_id) do
    GenServer.call(__MODULE__, {:get_client, user_id}, 10_000)
  end

  #####
  # GenServer implementation
  def init(opts) do
    # Use provided oauth_impl from opts, or fall back to the one from application config
    oauth_impl = 
      if Keyword.has_key?(opts, :oauth_impl) do
        Keyword.get(opts, :oauth_impl)
      else
        oauth_implementation()
      end
      
    {:ok, %State{oauth_impl: oauth_impl}}
  end

  def handle_call({:get_client, user_id}, _from, state) do
    try do
      client =
        case Map.get(state.clients, user_id) do
          nil -> create_client(user_id, state.oauth_impl)
          client -> refresh_client(client, state.oauth_impl)
        end

      updated_clients = Map.put(state.clients, user_id, client)

      {:reply, {:ok, client}, %{state | clients: updated_clients}}
    rescue
      error -> {:reply, {:error, error}, state}
    end
  end

  @doc """
  Async refreshes a token.
  """
  def handle_info({:refresh_token, user_id}, state) do
    client = Map.get(state.clients, user_id)
    refreshed_client = state.oauth_impl.refresh_token!(client, true)

    delay = state.oauth_impl.interval_refresh_token(refreshed_client)
    schedule_refresh_token(user_id, delay)

    updated_clients = Map.put(state.clients, user_id, refreshed_client)

    {:noreply, %{state | clients: updated_clients}}
  end

  defp create_client(user_id, oauth_impl) do
    client =
      [user_id: user_id]
      |> oauth_impl.client()
      |> oauth_impl.refresh_token!(true)

    delay = oauth_impl.interval_refresh_token(client)
    schedule_refresh_token(user_id, delay)

    client
  end

  defp refresh_client(client, oauth_impl) do
    oauth_impl.refresh_token!(client)
  end

  defp schedule_refresh_token(user_id, seconds) do
    Process.send_after(self(), {:refresh_token, user_id}, seconds * 1000)
  end

  defp oauth_implementation do
    Application.get_env(:docusign, :oauth_implementation, DocuSign.OAuth.Impl)
  end
end
