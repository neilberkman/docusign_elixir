defmodule DocuSign.OAuth do
  @moduledoc ~S"""
  This module defines the behaviour of the OAuth adapter.
  """

  @type client :: OAuth2.Client.t()
  @type error :: OAuth2.Error.t()
  @type access_token :: OAuth2.AccessToken.t()
  @type param :: binary | %{binary => param} | [param]
  @type params :: %{binary => param} | Keyword.t()
  @type headers :: [{binary, binary}]

  @doc """
  Create new API client
  """
  @callback client() :: client
  @callback client(Keyword.t()) :: client

  @doc """
  Retrieve access token and return a client
  """
  @callback get_token!(client) :: client | error
  @callback get_token!(client, params) :: client | error
  @callback get_token!(client, params, headers) :: client | error
  @callback get_token!(client, params, headers, Keyword.t()) :: client | error

  @doc """
  Refresh token
  """
  @type force :: boolean
  @callback refresh_token!(client) :: client
  @callback refresh_token!(client, force) :: client

  @doc """
  Retrieve a new time to auto refresh token.
  """
  @callback interval_refresh_token(client) :: integer

  @doc """
  Check expiration of token
  return true if token is expired
  """
  @callback token_expired?(access_token | nil | client) :: boolean
end
