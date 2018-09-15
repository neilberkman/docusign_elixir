defmodule DocuSign.APIClient do
  use GenServer

  alias DocuSign.{OAuth, Request}

  defstruct client_id: nil,
            user_id: nil,
            auth_token: %AuthToken{}

  #####
  # External API

  def start_link({client_id, user_id}) do
    GenServer.start_link(__MODULE__, {client_id, user_id}, name: __MODULE__)
  end

  def user_info() do
    GenServer.call(__MODULE__, {:user_info})
  end

  #####
  # GenServer implementation

  def init({client_id, user_id}) do
    state = %__MODULE__{
      client_id: client_id,
      user_id: user_id
    }

    {:ok, state}
  end

  def handle_call({:user_info}, _from, state) do
    {response, new_state} = call_api(state, "oauth/userinfo")
    {:reply, response, new_state}
  end

  ###
  # Private functions
  ##

  defp call_api(state, path, params \\ []) do
    new_state =
      if OAuth.token_invalid?(state.auth_token) do
        %{state | auth_token: OAuth.refreshed_auth_token(state)}
      else
        state
      end

    {Request.get(path, params, new_state.auth_token), new_state}
  end
end
