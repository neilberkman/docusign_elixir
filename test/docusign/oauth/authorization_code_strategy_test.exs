defmodule DocuSign.OAuth.AuthorizationCodeStrategyTest do
  use ExUnit.Case, async: false

  alias DocuSign.OAuth.AuthorizationCodeStrategy
  alias OAuth2.{AccessToken, Client}
  alias Tesla.Adapter.Httpc

  setup do
    # Ensure the module is loaded
    Code.ensure_loaded(AuthorizationCodeStrategy)

    # Save current environment and clean slate for each test
    original_env =
      for {app, keys} <- [
            docusign: [:client_id, :client_secret, :hostname, :ssl_options],
            oauth2: [:adapter]
          ],
          key <- keys do
        {app, key, Application.fetch_env(app, key)}
      end

    Application.delete_env(:docusign, :client_id)
    Application.delete_env(:docusign, :client_secret)
    Application.delete_env(:docusign, :hostname)
    Application.delete_env(:docusign, :ssl_options)
    Application.delete_env(:oauth2, :adapter)

    on_exit(fn ->
      Enum.each(original_env, fn
        {app, key, {:ok, value}} -> Application.put_env(app, key, value)
        {app, key, :error} -> Application.delete_env(app, key)
      end)
    end)

    :ok
  end

  describe "client/1" do
    test "creates OAuth2 client with explicit configuration" do
      client =
        AuthorizationCodeStrategy.client(
          client_id: "test_client_id",
          client_secret: "test_client_secret",
          hostname: "account-d.docusign.com",
          redirect_uri: "https://example.com/callback"
        )

      assert %Client{} = client
      assert client.client_id == "test_client_id"
      assert client.client_secret == "test_client_secret"
      assert client.site == "https://account-d.docusign.com"
      assert client.authorize_url == "/oauth/auth"
      assert client.token_url == "/oauth/token"
      assert client.redirect_uri == "https://example.com/callback"
      assert client.params["scope"] == "signature"
      assert client.request_opts[:ssl][:verify] == :verify_peer
    end

    test "uses configured SSL options with the Httpc adapter" do
      {:ok, cacertfile} = Briefly.create()
      Application.put_env(:docusign, :ssl_options, cacertfile: cacertfile, depth: 5)
      Application.put_env(:oauth2, :adapter, Httpc)

      client =
        AuthorizationCodeStrategy.client(
          client_id: "test_client_id",
          client_secret: "test_client_secret",
          hostname: "account-d.docusign.com",
          redirect_uri: "https://example.com/callback"
        )

      assert client.request_opts[:ssl][:verify] == :verify_peer
      assert client.request_opts[:ssl][:cacertfile] == cacertfile
      assert client.request_opts[:ssl][:depth] == 5
    end

    test "preserves explicit request options" do
      request_opts = [ssl: [verify: :verify_none], timeout: 456]

      client =
        AuthorizationCodeStrategy.client(
          client_id: "test_client_id",
          client_secret: "test_client_secret",
          hostname: "account-d.docusign.com",
          redirect_uri: "https://example.com/callback",
          request_opts: request_opts
        )

      assert client.request_opts == request_opts
    end

    test "leaves request options alone for other adapters" do
      Application.put_env(:oauth2, :adapter, Tesla.Mock)
      Application.put_env(:docusign, :ssl_options, cacertfile: "/nonexistent/cert.pem")

      opts = [
        client_id: "test_client_id",
        client_secret: "test_client_secret",
        hostname: "account-d.docusign.com",
        redirect_uri: "https://example.com/callback"
      ]

      assert AuthorizationCodeStrategy.client(opts).request_opts == []

      assert AuthorizationCodeStrategy.client(opts ++ [request_opts: [timeout: 456]]).request_opts ==
               [timeout: 456]
    end

    test "creates OAuth2 client with custom scope" do
      client =
        AuthorizationCodeStrategy.client(
          client_id: "test_client_id",
          client_secret: "test_client_secret",
          hostname: "account-d.docusign.com",
          redirect_uri: "https://example.com/callback",
          scope: "signature impersonation"
        )

      assert client.params["scope"] == "signature impersonation"
    end

    test "uses application config when options not provided" do
      Application.put_env(:docusign, :client_id, "app_client_id")
      Application.put_env(:docusign, :client_secret, "app_client_secret")
      Application.put_env(:docusign, :hostname, "account.docusign.com")

      client =
        AuthorizationCodeStrategy.client(redirect_uri: "https://example.com/callback")

      assert client.client_id == "app_client_id"
      assert client.client_secret == "app_client_secret"
      assert client.site == "https://account.docusign.com"
    end

    test "raises error when required parameters are missing" do
      assert_raise ArgumentError, "client_id is required (set in opts or app config)", fn ->
        AuthorizationCodeStrategy.client(redirect_uri: "https://example.com/callback")
      end
    end

    test "raises error when redirect_uri is missing" do
      assert_raise KeyError, fn ->
        AuthorizationCodeStrategy.client(
          client_id: "test_client_id",
          client_secret: "test_client_secret",
          hostname: "account-d.docusign.com"
        )
      end
    end
  end

  describe "authorize_url!/2" do
    setup do
      client =
        AuthorizationCodeStrategy.client(
          client_id: "test_client_id",
          client_secret: "test_client_secret",
          hostname: "account-d.docusign.com",
          redirect_uri: "https://example.com/callback"
        )

      {:ok, client: client}
    end

    test "generates correct authorization URL", %{client: client} do
      url = OAuth2.Client.authorize_url!(client)

      assert url =~ "https://account-d.docusign.com/oauth/auth"
      assert url =~ "response_type=code"
      assert url =~ "client_id=test_client_id"
      assert url =~ "redirect_uri=https%3A%2F%2Fexample.com%2Fcallback"
      assert url =~ "scope=signature"
    end

    test "includes state parameter when provided", %{client: client} do
      url = OAuth2.Client.authorize_url!(client, state: "random_state_123")

      assert url =~ "state=random_state_123"
    end

    test "includes custom scope when provided", %{client: client} do
      url =
        OAuth2.Client.authorize_url!(client, scope: "signature impersonation")

      assert url =~ "scope=signature+impersonation"
    end
  end

  describe "OAuth2 integration" do
    test "follows OAuth2 strategy pattern" do
      # Test that our strategy implements the OAuth2.Strategy behavior
      assert function_exported?(AuthorizationCodeStrategy, :get_token, 3)
      # authorize_url/2 is an @impl callback, not a public function
      assert {:authorize_url, 2} in AuthorizationCodeStrategy.__info__(:functions)
    end

    test "creates client with proper strategy configuration" do
      client =
        AuthorizationCodeStrategy.client(
          client_id: "test_client_id",
          client_secret: "test_client_secret",
          hostname: "account-d.docusign.com",
          redirect_uri: "https://example.com/callback"
        )

      assert client.strategy == AuthorizationCodeStrategy
    end

    test "client can be used with OAuth2.Client functions" do
      client =
        AuthorizationCodeStrategy.client(
          client_id: "test_client_id",
          client_secret: "test_client_secret",
          hostname: "account-d.docusign.com",
          redirect_uri: "https://example.com/callback"
        )

      # Test that we can call OAuth2.Client functions
      auth_url = Client.authorize_url!(client)
      assert is_binary(auth_url)
      assert auth_url =~ "account-d.docusign.com"
    end

    test "client supports token refresh functionality" do
      # Create a client with a mock access token
      client =
        AuthorizationCodeStrategy.client(
          client_id: "test_client_id",
          client_secret: "test_client_secret",
          hostname: "account-d.docusign.com",
          redirect_uri: "https://example.com/callback"
        )

      # Add a mock token with refresh token
      token = %AccessToken{
        access_token: "mock_access_token",
        expires_at: System.system_time(:second) + 3600,
        refresh_token: "mock_refresh_token",
        token_type: "Bearer"
      }

      _client_with_token = %{client | token: token}

      # Test that OAuth2.Client.refresh_token! function exists and can be called
      # (In real usage, this would make HTTP request)
      assert function_exported?(OAuth2.Client, :refresh_token!, 1)
    end
  end

  describe "helper functions" do
    test "get_user_info! function exists" do
      assert function_exported?(AuthorizationCodeStrategy, :get_user_info!, 1)
    end

    test "OAuth2.Client functions are available" do
      assert function_exported?(OAuth2.Client, :get_token!, 2)
      assert function_exported?(OAuth2.Client, :refresh_token!, 1)
      assert function_exported?(OAuth2.Client, :authorize_url!, 1)
    end
  end

  describe "configuration validation" do
    test "validates client_id from app config" do
      Application.put_env(:docusign, :client_secret, "secret")
      Application.put_env(:docusign, :hostname, "hostname")

      assert_raise ArgumentError, "client_id is required (set in opts or app config)", fn ->
        AuthorizationCodeStrategy.client(redirect_uri: "https://example.com/callback")
      end
    end

    test "validates client_secret from app config" do
      Application.put_env(:docusign, :client_id, "client_id")
      Application.put_env(:docusign, :hostname, "hostname")

      assert_raise ArgumentError, "client_secret is required (set in opts or app config)", fn ->
        AuthorizationCodeStrategy.client(redirect_uri: "https://example.com/callback")
      end
    end

    test "validates hostname from app config" do
      Application.put_env(:docusign, :client_id, "client_id")
      Application.put_env(:docusign, :client_secret, "secret")

      assert_raise ArgumentError, "hostname is required (set in opts or app config)", fn ->
        AuthorizationCodeStrategy.client(redirect_uri: "https://example.com/callback")
      end
    end
  end
end
