defmodule DocuSign.ConnectionOAuthTest do
  use ExUnit.Case, async: true

  alias DocuSign.Connection
  alias OAuth2.{AccessToken, Client}

  describe "from_oauth_client/2" do
    test "creates connection from OAuth2.Client with tokens" do
      oauth_client = %Client{
        token: %AccessToken{
          access_token: "oauth_access_token_123",
          expires_at: System.system_time(:second) + 28_800,
          refresh_token: "oauth_refresh_token_456",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "12345678-1234-1234-1234-123456789012",
          base_uri: "https://demo.docusign.net/restapi"
        )

      assert conn.client == oauth_client
      assert conn.app_account.account_id == "12345678-1234-1234-1234-123456789012"
      assert conn.app_account.base_uri == "https://demo.docusign.net/restapi"
    end

    test "returns error when account_id is missing" do
      oauth_client = %Client{
        token: %AccessToken{
          access_token: "oauth_access_token_123",
          token_type: "Bearer"
        }
      }

      {:error, reason} =
        Connection.from_oauth_client(
          oauth_client,
          base_uri: "https://demo.docusign.net/restapi"
        )

      assert reason == {:missing_required_option, :account_id}
    end

    test "returns error when base_uri is missing" do
      oauth_client = %Client{
        token: %AccessToken{
          access_token: "oauth_access_token_123",
          token_type: "Bearer"
        }
      }

      {:error, reason} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "12345678-1234-1234-1234-123456789012"
        )

      assert reason == {:missing_required_option, :base_uri}
    end
  end

  describe "Connection.Request.new/1 with OAuth2.Client" do
    test "creates Tesla client with OAuth2.Client authorization" do
      oauth_client = %Client{
        token: %AccessToken{
          access_token: "oauth_access_token_123",
          expires_at: System.system_time(:second) + 28_800,
          refresh_token: "oauth_refresh_token_456",
          token_type: "Bearer"
        }
      }

      conn = %Connection{
        app_account: %{
          base_uri: "https://demo.docusign.net/restapi"
        },
        client: oauth_client
      }

      tesla_client = Connection.Request.new(conn)

      # Check that Tesla client is created (we can't easily inspect middleware)
      assert %Tesla.Client{} = tesla_client
    end

    test "creates Tesla client with JWT token authorization (existing behavior)" do
      conn = %Connection{
        app_account: %{
          base_uri: "https://demo.docusign.net/restapi"
        },
        client: %{
          token: %{
            access_token: "jwt_access_token_123",
            token_type: "Bearer"
          }
        }
      }

      tesla_client = Connection.Request.new(conn)

      # Check that Tesla client is created (we can't easily inspect middleware)
      assert %Tesla.Client{} = tesla_client
    end
  end

  describe "Connection.request/2 with OAuth2.Client" do
    setup do
      bypass = Bypass.open()

      oauth_client = %Client{
        token: %AccessToken{
          access_token: "oauth_access_token_123",
          expires_at: System.system_time(:second) + 28_800,
          refresh_token: "oauth_refresh_token_456",
          token_type: "Bearer"
        }
      }

      conn = %Connection{
        app_account: %{
          base_uri: "http://localhost:#{bypass.port}"
        },
        client: oauth_client
      }

      {:ok, bypass: bypass, conn: conn}
    end

    test "makes successful request with OAuth2.Client", %{bypass: bypass, conn: conn} do
      Bypass.expect_once(bypass, "GET", "/test", fn conn ->
        # Verify the Authorization header
        auth_header = get_req_header(conn, "authorization") |> List.first()
        assert auth_header == "Bearer oauth_access_token_123"

        Plug.Conn.resp(conn, 200, Jason.encode!(%{"success" => true}))
      end)

      {:ok, response} = Connection.request(conn, method: :get, url: "/test")

      assert response.status == 200
      assert Jason.decode!(response.body) == %{"success" => true}
    end

    test "handles request errors with OAuth2.Client", %{bypass: bypass, conn: conn} do
      Application.put_env(:docusign, :structured_errors, true)

      Bypass.expect_once(bypass, "GET", "/error", fn conn ->
        Plug.Conn.resp(conn, 401, Jason.encode!(%{"error" => "unauthorized"}))
      end)

      {:error, error} = Connection.request(conn, method: :get, url: "/error")

      assert %DocuSign.AuthenticationError{} = error
      assert error.status == 401
    end

    defp get_req_header(conn, name) do
      Plug.Conn.get_req_header(conn, name)
    end
  end

  describe "Integration: OAuth2 strategy to Connection usage" do
    test "complete flow using OAuth2.Client" do
      # Simulate OAuth2.Client with tokens from authorization flow
      oauth_client = %Client{
        token: %AccessToken{
          access_token: "integration_access_token",
          expires_at: System.system_time(:second) + 28_800,
          refresh_token: "integration_refresh_token",
          token_type: "Bearer"
        }
      }

      # Create connection from OAuth2.Client
      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "12345678-1234-1234-1234-123456789012",
          base_uri: "https://demo.docusign.net/restapi"
        )

      # Verify connection structure
      assert conn.client == oauth_client
      assert conn.app_account.account_id == "12345678-1234-1234-1234-123456789012"
      assert conn.app_account.base_uri == "https://demo.docusign.net/restapi"

      # Verify we can create a Tesla client for requests
      tesla_client = Connection.Request.new(conn)
      assert %Tesla.Client{} = tesla_client
    end

    test "connection works with typical DocuSign API patterns" do
      oauth_client = %Client{
        token: %AccessToken{
          access_token: "api_access_token",
          expires_at: System.system_time(:second) + 28_800,
          refresh_token: "api_refresh_token",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "api-account-id",
          base_uri: "https://demo.docusign.net/restapi"
        )

      # This connection structure should work with existing DocuSign API modules
      # We can't test actual API calls without mocking, but we can verify structure
      assert is_map(conn.app_account)
      assert %Client{} = conn.client

      # Verify compatibility with Connection.request/2
      assert is_function(&Connection.request/2, 2)
    end
  end
end
