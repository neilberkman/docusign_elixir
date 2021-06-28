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
  @spec client(Keyword.t()) :: OAuth2.Client.t()
  def client(opts \\ []) do
    user_id = Keyword.get(opts, :user_id, default_user_id())
    GenServer.call(__MODULE__, {:get_client, user_id, opts}, 10_000)
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

  def handle_call({:get_client, user_id, opts}, _from, nil) do
    oauth_impl = Keyword.get(opts, :oauth_impl, OAuth.Impl)
    client = oauth_impl.refresh_token!(oauth_impl.client(user_id: user_id), true)
    client |> oauth_impl.interval_refresh_token() |> schedule_refresh_token
    {:reply, client, client}
  end

  def handle_call({:get_client, _user_id, opts}, _from, client) do
    oauth_impl = Keyword.get(opts, :oauth_impl, OAuth.Impl)
    refresh_client = oauth_impl.refresh_token!(client)
    {:reply, refresh_client, refresh_client}
  end

  @doc """
  Sync refreshes a token.
  """
  def handle_call(:refresh_token, _from, client) do
    new_client = OAuth.Impl.refresh_token!(client, true)
    {:reply, new_client, new_client}
  end

  @doc """
  Async refreshes a token.
  """
  def handle_info(:refresh_token, client) do
    new_client = OAuth.Impl.refresh_token!(client, true)

    new_client
    |> OAuth.Impl.interval_refresh_token()
    |> schedule_refresh_token

    {:noreply, new_client}
  end

  defp schedule_refresh_token(seconds) do
    Process.send_after(self(), :refresh_token, seconds * 1000)
  end

  defp default_user_id do
    Application.fetch_env!(:docusign, :user_id)
  end
end
