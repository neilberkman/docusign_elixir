defmodule DocuSign.OAuth.AuthorizationCodeStrategy do
  @moduledoc """
  OAuth2 Authorization Code Flow strategy for DocuSign using the battle-tested oauth2 library.

  This module implements the standard OAuth2 Authorization Code Flow for DocuSign,
  leveraging the existing OAuth2 library infrastructure used by the JWT impersonation flow.

  ## Usage

      # Create client
      client = DocuSign.OAuth.AuthorizationCodeStrategy.client(
        client_id: "your_integration_key",
        client_secret: "your_secret",
        redirect_uri: "https://yourapp.com/auth/docusign/callback"
      )

      # Generate authorization URL
      auth_url = OAuth2.Client.authorize_url!(client, scope: "signature")

      # Exchange authorization code for tokens
      client = OAuth2.Client.get_token!(client, code: "auth_code_from_callback")

      # Get DocuSign user info
      user_info = DocuSign.OAuth.AuthorizationCodeStrategy.get_user_info!(client)

  ## Configuration

      config :docusign,
        client_id: "your_integration_key",
        client_secret: "your_secret_key",
        hostname: "account-d.docusign.com"  # or "account.docusign.com" for production
  """

  use OAuth2.Strategy

  alias OAuth2.{Client, Strategy.AuthCode}

  @doc """
  Create a new OAuth2 client for DocuSign Authorization Code Flow.

  ## Parameters

  - `opts` - Keyword list of options:
    - `:client_id` - DocuSign integration key (required if not in app config)
    - `:client_secret` - DocuSign secret (required if not in app config)
    - `:hostname` - DocuSign hostname (required if not in app config)
    - `:redirect_uri` - Callback URL for authorization (required)
    - `:scope` - OAuth scopes (default: "signature")

  ## Examples

      # With explicit configuration
      client = DocuSign.OAuth.AuthorizationCodeStrategy.client(
        client_id: "your_integration_key",
        client_secret: "your_secret",
        hostname: "account-d.docusign.com",
        redirect_uri: "https://yourapp.com/auth/callback"
      )

      # Using application config
      client = DocuSign.OAuth.AuthorizationCodeStrategy.client(
        redirect_uri: "https://yourapp.com/auth/callback"
      )

  ## Returns

  Returns an `OAuth2.Client` struct configured for DocuSign Authorization Code Flow.
  """
  @spec client(keyword()) :: OAuth2.Client.t()
  def client(opts \\ []) do
    client_id = get_required_option(opts, :client_id, &get_client_id/0)
    client_secret = get_required_option(opts, :client_secret, &get_client_secret/0)
    hostname = get_required_option(opts, :hostname, &get_hostname/0)
    redirect_uri = Keyword.fetch!(opts, :redirect_uri)
    scope = Keyword.get(opts, :scope, "signature")

    [
      strategy: __MODULE__,
      client_id: client_id,
      client_secret: client_secret,
      site: "https://#{hostname}",
      authorize_url: "/oauth/auth",
      token_url: "/oauth/token",
      redirect_uri: redirect_uri
    ]
    |> Keyword.merge(opts)
    |> Client.new()
    |> Client.put_serializer("application/json", Jason)
    |> Client.put_param(:scope, scope)
  end

  @doc """
  Get DocuSign user information using the access token.

  ## Parameters

  - `client` - OAuth2.Client with valid access token

  ## Examples

      user_info = get_user_info!(client)
      user_email = user_info["email"]
      accounts = user_info["accounts"]

  ## Returns

  Returns user information map from DocuSign /oauth/userinfo endpoint.
  """
  @spec get_user_info!(OAuth2.Client.t()) :: map()
  def get_user_info!(client) do
    case Client.get(client, "/oauth/userinfo") do
      {:ok, %{body: body}} -> body
      {:error, error} -> raise "Failed to get user info: #{inspect(error)}"
    end
  end

  # OAuth2.Strategy callbacks

  @impl OAuth2.Strategy
  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  @impl OAuth2.Strategy
  def get_token(client, params, headers) do
    client
    |> Client.put_param(:grant_type, "authorization_code")
    |> Client.put_param(:code, params[:code])
    |> Client.put_param(:redirect_uri, client.redirect_uri)
    |> Client.put_header("accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end

  # Private helper functions

  defp get_required_option(opts, key, fallback_fn) do
    case Keyword.fetch(opts, key) do
      {:ok, value} -> value
      :error -> fallback_fn.()
    end
  end

  defp get_client_id do
    case Application.fetch_env(:docusign, :client_id) do
      {:ok, client_id} -> client_id
      :error -> raise ArgumentError, "client_id is required (set in opts or app config)"
    end
  end

  defp get_client_secret do
    case Application.fetch_env(:docusign, :client_secret) do
      {:ok, client_secret} -> client_secret
      :error -> raise ArgumentError, "client_secret is required (set in opts or app config)"
    end
  end

  defp get_hostname do
    case Application.fetch_env(:docusign, :hostname) do
      {:ok, hostname} -> hostname
      :error -> raise ArgumentError, "hostname is required (set in opts or app config)"
    end
  end
end
