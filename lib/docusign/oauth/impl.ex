defmodule DocuSign.OAuth.Impl do
  @moduledoc ~S"""
  This module implements the OAuth behaviour and an oauth2 strategy for DocuSign.

  ### Examples

  client = DocuSign.OAuth.Impl.client() |> DocuSign.OAuth.Impl.get_token!()
  {:ok, user_info } = OAuth2.Client.get(client, "/oauth/userinfo")

  """
  @behaviour DocuSign.OAuth

  use OAuth2.Strategy

  alias OAuth2.{AccessToken, Client, Error}

  require Logger

  @type param :: binary | %{binary => param} | [param]
  @type params :: %{binary => param} | Keyword.t()
  @type headers :: [{binary, binary}]

  @grant_type "urn:ietf:params:oauth:grant-type:jwt-bearer"
  @client_info_path "/oauth/userinfo"

  @impl DocuSign.OAuth
  def client(opts \\ []) do
    user_id = Keyword.get(opts, :user_id, get_default_user_id())
    client_id = Application.fetch_env!(:docusign, :client_id)
    hostname = Application.fetch_env!(:docusign, :hostname)
    token_expires_in = Application.get_env(:docusign, :token_expires_in, 2 * 60 * 60)

    [
      strategy: __MODULE__,
      client_id: client_id,
      ref: %{
        hostname: hostname,
        token_expires_in: token_expires_in,
        user_id: user_id
      },
      site: "https://#{hostname}",
      authorize_url: "oauth/auth?response_type=code&scope=signature%20impersonation"
    ]
    |> Keyword.merge(opts)
    |> Client.new()
    |> Client.put_serializer("application/json", Jason)
  end

  defp get_default_user_id do
    Application.get_env(:docusign, :user_id)
  end

  @impl DocuSign.OAuth
  def get_token!(client, params \\ [], headers \\ [], opts \\ []) do
    Client.get_token!(client, params, headers, opts)
  end

  @impl DocuSign.OAuth
  def refresh_token!(client, force \\ false) do
    if force || token_expired?(client) do
      Client.get_token!(client)
    else
      client
    end
  end

  @impl DocuSign.OAuth
  def interval_refresh_token(client), do: client.token.expires_at - :erlang.system_time(:second) - 10

  @impl DocuSign.OAuth
  def token_expired?(%AccessToken{} = token), do: AccessToken.expired?(token)
  def token_expired?(nil), do: true
  def token_expired?(%Client{token: nil}), do: true
  def token_expired?(%Client{token: token}), do: token_expired?(token)

  @impl DocuSign.OAuth
  def get_client_info(client) do
    case Client.get(client, @client_info_path) do
      {:ok, %{body: body}} ->
        body

      {:error, error} ->
        Logger.error("Failed to get client info: #{inspect(error)}")
        nil
    end
  end

  @impl OAuth2.Strategy
  @spec get_token(OAuth2.Client.t(), any, any) :: OAuth2.Client.t()
  def get_token(client, _params, _headers) do
    client
    |> put_param(:grant_type, @grant_type)
    |> put_param(:assertion, assertion(client))
  end

  # OAuth2.Strategy callback

  @impl OAuth2.Strategy
  def authorize_url(_client, _params) do
    raise Error, reason: "This strategy does not implement `authorize_url`."
  end

  # Create claim and sign with private key
  #
  @spec assertion(Client.t()) :: binary | no_return()
  defp assertion(client) do
    client
    |> claims()
    |> generate_and_sign!()
  end

  defp claims(client) do
    now_unix = :erlang.system_time(:second)

    %{
      "aud" => client.ref.hostname,
      "exp" => now_unix + client.ref.token_expires_in,
      "iat" => now_unix,
      "iss" => client.client_id,
      "scope" => "signature",
      "sub" => client.ref.user_id
    }
  end

  # Signed payload use token key
  #
  @spec generate_and_sign!(map) :: binary | no_return()
  defp generate_and_sign!(claims) do
    Joken.generate_and_sign!(%{}, claims, token_signer())
  end

  # Take token signer from application env and if it doesn't exist, create it.
  #
  @spec token_signer :: Joken.Signer.t()
  defp token_signer do
    case Application.fetch_env(:docusign, :token_signer) do
      {:ok, token_signer} ->
        token_signer

      :error ->
        token_signer = create_token_signer()
        Application.put_env(:docusign, :token_signer, token_signer)
        token_signer
    end
  end

  # Create token signer based on PEM-encoded key.
  #
  @spec create_token_signer :: Joken.Signer.t()
  defp create_token_signer do
    private_key_file = Application.get_env(:docusign, :private_key_file)
    private_key_contents = Application.get_env(:docusign, :private_key_contents)
    # In v2.0, we don't handle private_key anymore (deprecated)

    case {private_key_file, private_key_contents} do
      {nil, nil} ->
        raise "No private key found in application environment. Please set :private_key_file or :private_key_contents."

      {private_key_file, nil} when is_binary(private_key_file) ->
        token_signer_from_file(private_key_file)

      {nil, private_key_contents} when is_binary(private_key_contents) ->
        token_signer_from_contents(private_key_contents)

      _ ->
        raise "Multiple DocuSign private keys were provided. Please use only one of :private_key_file or :private_key_contents."
    end
  end

  defp token_signer_from_file(file_path) do
    file_path
    |> File.read!()
    |> token_signer_from_contents()
  end

  defp token_signer_from_contents(contents) do
    Joken.Signer.create("RS256", %{"pem" => contents})
  end
end
