defmodule DocuSign.OAuth do
  @moduledoc ~S"""
  This module implements an oauth2 strategy for DocuSign.

  ### Examples

  client = DocuSign.OAuth2Strategy.get_token!
  {:ok, user_info } = OAuth2.Client.get(client, "/oauth/userinfo")

  """
  use OAuth2.Strategy

  alias OAuth2.{AccessToken, Client, Error}
  @type param :: binary | %{binary => param} | [param]
  @type params :: %{binary => param} | Keyword.t()
  @type headers :: [{binary, binary}]

  @grant_type "urn:ietf:params:oauth:grant-type:jwt-bearer"

  @doc """
  Retrieve access token and return a client
  """
  @spec get_token!(Client.t(), params, headers, Keyword.t()) :: Client.t() | Error.t()
  def get_token!(client, params \\ [], headers \\ [], opts \\ []) do
    Client.get_token!(client, params, headers, opts)
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
    do: client.token.expires_at - :erlang.system_time(:second) - 10

  @doc """
  Check expiration of token
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
      client_id: Application.fetch_env!(:docusign, :client_id),
      site: "https://#{Application.fetch_env!(:docusign, :hostname)}",
      authorize_url: "oauth/auth?response_type=code&scope=signature%20impersonation"
    ]
    |> Keyword.merge(opts)
    |> Client.new()
    |> Client.put_serializer("application/json", Poison)
  end

  # OAuth2.Strategy callback
  #
  @spec get_token(Client.t(), Keyword.t(), Keyword.t()) :: binary | no_return()
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

  # Create claim and sign with private key
  #
  @spec assertion() :: binary | no_return()
  def assertion do
    generate_and_sign!(claims())
  end

  # Signed payload use token key
  #
  @spec generate_and_sign!(map) :: binary | no_return()
  defp generate_and_sign!(claims) do
    Joken.generate_and_sign!(%{}, claims, token_signer())
  end

  defp claims do
    now_unix = :erlang.system_time(:second)

    %{
      "iss" => Application.fetch_env!(:docusign, :client_id),
      "sub" => Application.fetch_env!(:docusign, :user_id),
      "aud" => Application.fetch_env!(:docusign, :hostname),
      "iat" => now_unix,
      "exp" => now_unix + Application.get_env(:docusign, :token_expires_in, 2 * 60 * 60),
      "scope" => "signature"
    }
  end

  # Take token signer from application env and if it doesn't exist, create it.
  #
  @spec token_signer(pem_key :: String.t()) :: Joken.Signer.t()
  defp token_signer(pem_key \\ nil) do
    case Application.fetch_env(:docusign, :token_signer) do
      {:ok, token_signer} ->
        token_signer

      :error ->
        token_signer = create_token_signer(pem_key)
        Application.put_env(:docusign, :token_signer, token_signer)
        token_signer
    end
  end

  # Create token signer based on PEM-encoded key. If the provided `pem_key` is
  # `nil`, load it from the application environment.
  #
  @spec create_token_signer(pem_key :: String.t()) :: Joken.Signer.t()
  defp create_token_signer(pem_key) do
    Joken.Signer.create("RS256", %{"pem" => pem_key || token_key()})
  end

  defp token_key do
    :docusign
    |> Application.fetch_env!(:private_key)
    |> File.read!()
  end
end
