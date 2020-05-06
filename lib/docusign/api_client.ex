defmodule DocuSign.APIClient do
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
  @spec client() :: OAuth2.Client.t()
  def client do
    GenServer.call(__MODULE__, :get_client, 10_000)
  end

  @doc """
  Forces an access token refresh.
  """
  @spec refresh_token() :: OAuth2.Client.t()
  def refresh_token do
    GenServer.call(__MODULE__, :refresh_token, 10_000)
  end

  #####
  # GenServer implementation
  def init(_opts) do
    {:ok, nil}
  end

  def handle_call(:get_client, _from, nil) do
    client = OAuth.refresh_token!(OAuth.client(), true)
    client |> OAuth.interval_refresh_token() |> schedule_refresh_token
    {:reply, client, client}
  end

  def handle_call(:get_client, _from, client) do
    refresh_client = OAuth.refresh_token!(client)
    {:reply, refresh_client, refresh_client}
  end

  @doc """
  Sync refreshes a token.
  """
  def handle_call(:refresh_token, _from, client) do
    new_client = OAuth.refresh_token!(client, true)
    {:reply, new_client, new_client}
  end

  @doc """
  Async refreshes a token.
  """
  def handle_info(:refresh_token, client) do
    new_client = OAuth.refresh_token!(client, true)

    new_client
    |> OAuth.interval_refresh_token()
    |> schedule_refresh_token

    {:noreply, new_client}
  end

  defp schedule_refresh_token(seconds) do
    Process.send_after(self(), :refresh_token, seconds * 1000)
  end
end
