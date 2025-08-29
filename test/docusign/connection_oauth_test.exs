defmodule DocuSign.ConnectionOAuthTest do
  # Modifies global config, can't run async
  use ExUnit.Case, async: false

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

      # Verify Req client is created
      assert %Req.Request{} = conn.req
      assert conn.req.options.base_url == "https://demo.docusign.net/restapi"
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

      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "http://localhost:#{bypass.port}"
        )

      {:ok, bypass: bypass, conn: conn}
    end

    test "sends request with OAuth2 authorization header", %{bypass: bypass, conn: conn} do
      Bypass.expect_once(bypass, fn conn_b ->
        assert Plug.Conn.get_req_header(conn_b, "authorization") == [
                 "Bearer oauth_access_token_123"
               ]

        conn_b
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, ~s({"result": "success"}))
      end)

      {:ok, response} = Connection.request(conn, method: :get, url: "/test")

      assert response.status == 200
      assert response.body == %{"result" => "success"}
    end

    test "includes content-type header", %{bypass: bypass, conn: conn} do
      Bypass.expect_once(bypass, fn conn_b ->
        assert Plug.Conn.get_req_header(conn_b, "content-type") == ["application/json"]
        Plug.Conn.resp(conn_b, 200, "")
      end)

      {:ok, _response} = Connection.request(conn, method: :get, url: "/test")
    end
  end

  describe "from_oauth_client_with_detection/2" do
    test "auto-detects sandbox hostname when enabled" do
      original_hostname = Application.get_env(:docusign, :hostname)

      oauth_client = %Client{
        token: %AccessToken{
          access_token: "oauth_access_token_123",
          token_type: "Bearer"
        }
      }

      {:ok, _conn} =
        Connection.from_oauth_client_with_detection(
          oauth_client,
          account_id: "test-account",
          base_uri: "https://demo.docusign.net/restapi",
          auto_detect_hostname: true
        )

      # Verify hostname was auto-detected as sandbox
      assert Application.get_env(:docusign, :hostname) == "account-d.docusign.com"

      # Cleanup
      if original_hostname do
        Application.put_env(:docusign, :hostname, original_hostname)
      else
        Application.delete_env(:docusign, :hostname)
      end
    end

    test "auto-detects production hostname when enabled" do
      original_hostname = Application.get_env(:docusign, :hostname)

      oauth_client = %Client{
        token: %AccessToken{
          access_token: "oauth_access_token_123",
          token_type: "Bearer"
        }
      }

      {:ok, _conn} =
        Connection.from_oauth_client_with_detection(
          oauth_client,
          account_id: "test-account",
          base_uri: "https://na3.docusign.net/restapi",
          auto_detect_hostname: true
        )

      # Verify hostname was auto-detected as production
      assert Application.get_env(:docusign, :hostname) == "account.docusign.com"

      # Cleanup
      if original_hostname do
        Application.put_env(:docusign, :hostname, original_hostname)
      else
        Application.delete_env(:docusign, :hostname)
      end
    end

    test "skips detection when disabled" do
      original_hostname = Application.get_env(:docusign, :hostname)
      Application.put_env(:docusign, :hostname, "test-hostname.com")

      oauth_client = %Client{
        token: %AccessToken{
          access_token: "oauth_access_token_123",
          token_type: "Bearer"
        }
      }

      {:ok, _conn} =
        Connection.from_oauth_client_with_detection(
          oauth_client,
          account_id: "test-account",
          base_uri: "https://demo.docusign.net/restapi",
          auto_detect_hostname: false
        )

      # Verify hostname was NOT changed
      assert Application.get_env(:docusign, :hostname) == "test-hostname.com"

      # Cleanup
      if original_hostname do
        Application.put_env(:docusign, :hostname, original_hostname)
      else
        Application.delete_env(:docusign, :hostname)
      end
    end
  end
end
