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
  Forcing refresh access token.
  """
  @spec refresh_token() :: OAuth2.Client.t()
  def refresh_token do
    GenServer.call(__MODULE__, :refresh_token, 10_000)
  end

  #####
  # GenServer implementation

  def init(_opts) do
    schedule_refresh_token(0)
    {:ok, OAuth.client()}
  end

  def handle_call(:get_client, _from, client) do
    refresh_client = refresh_token(client)
    {:reply, refresh_client, refresh_client}
  end

  def handle_call(:refresh_token, _from, client) do
    new_client = refresh_token(client, true)
    {:reply, new_client, new_client}
  end

  def handle_cast(:refresh_token, client) do
    new_client = refresh_token(client, true)
    next_time = new_client.token.expires_at - :os.system_time(:seconds) - 10
    schedule_refresh_token(next_time)
    {:noreply, new_client}
  end

  defp refresh_token(client, force \\ false) do
    if force || OAuth.token_expired?(client) do
      OAuth.get_token!(client)
    else
      client
    end
  end

  defp schedule_refresh_token(seconds) do
    Process.send_after(self(), {:"$gen_cast", :refresh_token}, seconds * 1000)
  end
end
