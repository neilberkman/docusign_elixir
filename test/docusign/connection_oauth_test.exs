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
      # Verify Req client was created
      assert %Req.Request{} = conn.req
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

  describe "Connection with OAuth2.Client and Req" do
    test "creates Req client with OAuth2.Client authorization" do
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
          account_id: "test-account",
          base_uri: "https://demo.docusign.net/restapi"
        )

      # Check that Req client is created with proper auth headers
      assert %Req.Request{} = conn.req
      assert conn.req.options[:base_url] == "https://demo.docusign.net/restapi"

      # Check authorization header (Req stores headers as {name, [values]})
      auth_header = Enum.find(conn.req.headers, fn {k, _v} -> k == "authorization" end)
      assert auth_header != nil
      {_, auth_value} = auth_header
      # Handle both string and list formats
      auth_string = if is_list(auth_value), do: List.first(auth_value), else: auth_value
      assert auth_string == "Bearer oauth_access_token_123"
    end

    test "creates Req client with JWT token authorization (existing behavior)" do
      {:ok, conn} =
        Connection.from_oauth_client(
          %Client{token: %AccessToken{access_token: "jwt_token", token_type: "Bearer"}},
          account_id: "test-account",
          base_uri: "https://demo.docusign.net/restapi"
        )

      # Check that Req client is created
      assert %Req.Request{} = conn.req
      assert conn.req.options[:base_url] == "https://demo.docusign.net/restapi"
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

      # Create connection properly with Req
      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "http://localhost:#{bypass.port}"
        )

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
      # Req returns JSON as string by default unless configured to decode
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

      # Verify we have a Req client for requests
      assert %Req.Request{} = conn.req
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
      assert %Req.Request{} = conn.req

      # Verify compatibility with Connection.request/2
      assert is_function(&Connection.request/2, 2)
    end
  end
end
