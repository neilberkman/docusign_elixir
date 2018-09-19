defmodule DocuSign.OAuth do
  @moduledoc ~S"""
  This module implements an oauth2 strategy for DocuSign.

  ### Examples

  client = DocuSign.OAuth2Strategy.get_token!
  {:ok, user_info } = OAuth2.Client.get(client, "/oauth/userinfo")

  """
  use OAuth2.Strategy

  alias OAuth2.{Client, AccessToken, Error}
  @type param :: binary | %{binary => param} | [param]
  @type params :: %{binary => param} | Keyword.t()
  @type headers :: [{binary, binary}]

  @private_key Application.get_env(:docusign, :private_key)
  @token_expires_in Application.get_env(:docusign, :token_expires_in)
  @hostname Application.get_env(:docusign, :hostname)
  @client_id Application.get_env(:docusign, :client_id)
  @user_id Application.get_env(:docusign, :user_id)

  @grant_type "urn:ietf:params:oauth:grant-type:jwt-bearer"

  @doc """
  Retrieve access token and return a client
  """
  @spec get_token!(Client.t(), params, headers, Keyword.t()) :: Client.t() | Error.t()
  def get_token!(client, params \\ [], headers \\ [], opts \\ []) do
    client
    |> Client.get_token!(params, headers, opts)
  end

  @doc """
  Refresh token
  """
  @spec refresh_token!(Client.t(), boolean) :: Client.t()
  def refresh_token!(client, force \\ false) do
    if force || token_expired?(client) do
      Client.get_token!(client)
    else
      client
    end
  end

  @doc """
  Retrieve a new time to auto refresh token.
  """
  @spec interval_refresh_token(Client.t()) :: integer
  def interval_refresh_token(client),
    do: client.token.expires_at - :os.system_time(:seconds) - 10

  @doc """
  Check expiries of token.
  return true if token is expired
  """
  @spec token_expired?(AccessToken.t() | nil | Client.t()) :: boolean
  def token_expired?(%AccessToken{} = token), do: AccessToken.expired?(token)
  def token_expired?(nil), do: true
  def token_expired?(%Client{token: nil}), do: true
  def token_expired?(%Client{token: token}), do: token_expired?(token)

  @doc """
  Create new API client
  """
  @spec client(Keyword.t()) :: Client.t()
  def client(opts \\ []) do
    [
      strategy: __MODULE__,
      client_id: @client_id,
      site: "https://#{@hostname}"
    ]
    |> Keyword.merge(opts)
    |> Client.new()
  end

  # OAuth2.Strategy callback
  #
  @spec get_token(Client.t(), Keyword.t(), Keyword.t()) :: binary
  def get_token(client, _params, _headers) do
    client
    |> put_param(:grant_type, @grant_type)
    |> put_param(:assertion, assertion())
  end

  # OAuth2.Strategy callback
  #
  def authorize_url(_client, _params) do
    raise Error, reason: "This strategy does not implement `authorize_url`."
  end

  # Take token_key from pem file
  #
  @spec token_key() :: binary
  defp token_key do
    @private_key
    |> JOSE.JWK.from_pem_file()
    |> Joken.rs256()
  end

  # Signed payload use token key
  #
  @spec signed(map) :: binary
  defp signed(payload) do
    payload
    |> Joken.token()
    |> Joken.sign(token_key())
    |> Joken.get_compact()
  end

  # Create claim and sign with private key
  #
  @spec assertion() :: binary
  defp assertion() do
    now_unix = :os.system_time(:seconds)

    %{
      iss: @client_id,
      sub: @user_id,
      aud: @hostname,
      iat: now_unix,
      exp: now_unix + @token_expires_in,
      scope: "signature"
    }
    |> signed
  end
end
