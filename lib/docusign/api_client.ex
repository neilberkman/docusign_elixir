defmodule DocuSign.APIClient do
  @moduledoc ~S"""
  Deprecated interface to manage OAuth2 clients. `DocuSign.ClientRegistry` should be used
  instead.
  """

  alias DocuSign.ClientRegistry

  @doc """
  Get Api Client
  """
  @deprecated "Use DocuSign.ClientRegistry.client/1 instead."
  @spec client() :: {:ok, OAuth2.Client.t()} | {:error, any()}
  def client do
    ClientRegistry.client(default_user_id())
  end

  @doc """
  Forces an access token refresh.
  """
  @deprecated "Use DocuSign.ClientRegistry.refresh_token/1 instead."
  @spec refresh_token() :: {:ok, OAuth2.Client.t()} | {:error, any()}
  def refresh_token do
    # TO BE IMPLEMENTED
    # ClientRegistry.refresh_token(default_user_id())
    ClientRegistry.client(default_user_id())
  end

  defp default_user_id do
    Application.get_env(:docusign, :user_id)
  end
end
