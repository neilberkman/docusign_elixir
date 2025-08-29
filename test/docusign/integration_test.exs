defmodule DocuSign.IntegrationTest do
  # Integration tests modify global config, can't run async
  use ExUnit.Case, async: false

  alias DocuSign.OAuth.Fake

  setup do
    bypass = Bypass.open()

    # Store original config for cleanup
    original_hostname = Application.get_env(:docusign, :hostname)
    original_client_id = Application.get_env(:docusign, :client_id)
    original_user_id = Application.get_env(:docusign, :user_id)
    original_private_key_file = Application.get_env(:docusign, :private_key_file)
    original_oauth_implementation = Application.get_env(:docusign, :oauth_implementation)

    # Configure the app to use our test server
    Application.put_env(:docusign, :hostname, "localhost:#{bypass.port}")
    Application.put_env(:docusign, :client_id, "test_client_id")
    Application.put_env(:docusign, :user_id, "test_user_id")
    Application.put_env(:docusign, :private_key_file, "test/support/test_key")
    Application.put_env(:docusign, :oauth_implementation, Fake)

    # Start ClientRegistry if not already running with Fake implementation
    case Process.whereis(DocuSign.ClientRegistry) do
      nil ->
        {:ok, _} = DocuSign.ClientRegistry.start_link(oauth_impl: Fake)

      pid ->
        # Stop existing registry and start with Fake implementation
        Process.exit(pid, :kill)
        {:ok, _} = DocuSign.ClientRegistry.start_link(oauth_impl: Fake)
    end

    # Add cleanup function
    on_exit(fn ->
      # Restore original config
      if original_hostname do
        Application.put_env(:docusign, :hostname, original_hostname)
      else
        Application.delete_env(:docusign, :hostname)
      end

      if original_client_id do
        Application.put_env(:docusign, :client_id, original_client_id)
      else
        Application.delete_env(:docusign, :client_id)
      end

      if original_user_id do
        Application.put_env(:docusign, :user_id, original_user_id)
      else
        Application.delete_env(:docusign, :user_id)
      end

      if original_private_key_file do
        Application.put_env(:docusign, :private_key_file, original_private_key_file)
      else
        Application.delete_env(:docusign, :private_key_file)
      end

      if original_oauth_implementation do
        Application.put_env(:docusign, :oauth_implementation, original_oauth_implementation)
      else
        Application.delete_env(:docusign, :oauth_implementation)
      end
    end)

    {:ok, bypass: bypass}
  end

  describe "envelope creation workflow" do
    test "creates envelope, gets recipient view, and retrieves status", %{bypass: bypass} do
      # Load fixtures
      create_envelope_response =
        File.read!("test/fixtures/api_responses/create_envelope_201.json")

      recipient_view_response = File.read!("test/fixtures/api_responses/recipient_view_201.json")

      envelope_status_response =
        File.read!("test/fixtures/api_responses/envelope_status_200.json")

      # Mock OAuth token endpoint (not needed with Fake OAuth but kept for completeness)
      # Using stub instead of expect since Fake OAuth doesn't make HTTP calls
      Bypass.stub(bypass, "POST", "/oauth/token", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(
          200,
          Jason.encode!(%{
            "access_token" => "test_access_token",
            "expires_in" => 3600,
            "token_type" => "Bearer"
          })
        )
      end)

      # Mock user info endpoint (not needed with Fake OAuth but kept for completeness)
      # Using stub instead of expect since Fake OAuth doesn't make HTTP calls
      Bypass.stub(bypass, "GET", "/oauth/userinfo", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(
          200,
          Jason.encode!(%{
            "accounts" => [
              %{
                "account_id" => "17035828",
                "account_name" => "Test Account",
                "base_uri" => "http://localhost:#{bypass.port}",
                "is_default" => true
              }
            ],
            "email" => "test@example.com",
            "name" => "Test User",
            "sub" => "test_user_id"
          })
        )
      end)

      # Get connection
      {:ok, conn} = DocuSign.Connection.get("test_user_id")

      # Test 1: Create envelope
      Bypass.expect_once(bypass, "POST", "/restapi/v2.1/accounts/17035828/envelopes", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        request_body = Jason.decode!(body)

        # Verify request structure
        assert request_body["emailSubject"]
        assert request_body["status"] == "sent"
        assert request_body["documents"]
        assert request_body["recipients"]["signers"]

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(201, create_envelope_response)
      end)

      envelope_request = %{
        "documents" => [
          %{
            "documentBase64" => Base.encode64("Test content"),
            "documentId" => "1",
            "fileExtension" => "txt",
            "name" => "Test Doc"
          }
        ],
        "emailSubject" => "Test Document",
        "recipients" => %{
          "signers" => [
            %{
              "clientUserId" => "client123",
              "email" => "signer@example.com",
              "name" => "Test Signer",
              "recipientId" => "1"
            }
          ]
        },
        "status" => "sent"
      }

      {:ok, response} =
        DocuSign.Connection.request(conn,
          method: :post,
          url: "/v2.1/accounts/17035828/envelopes",
          json: envelope_request
        )

      assert response.status == 201
      assert response.body["envelopeId"]
      envelope_id = response.body["envelopeId"]

      # Test 2: Get recipient view
      Bypass.expect_once(
        bypass,
        "POST",
        "/restapi/v2.1/accounts/17035828/envelopes/#{envelope_id}/views/recipient",
        fn conn ->
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          request_body = Jason.decode!(body)

          # Verify request structure
          assert request_body["returnUrl"]
          assert request_body["authenticationMethod"]
          assert request_body["email"]
          assert request_body["userName"]
          assert request_body["clientUserId"]

          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.resp(201, recipient_view_response)
        end
      )

      recipient_view_request = %{
        "authenticationMethod" => "none",
        "clientUserId" => "client123",
        "email" => "signer@example.com",
        "returnUrl" => "https://example.com/return",
        "userName" => "Test Signer"
      }

      {:ok, response} =
        DocuSign.Connection.request(conn,
          method: :post,
          url: "/v2.1/accounts/17035828/envelopes/#{envelope_id}/views/recipient",
          json: recipient_view_request
        )

      assert response.status == 201
      assert response.body["url"]

      # Test 3: Get envelope status
      Bypass.expect_once(
        bypass,
        "GET",
        "/restapi/v2.1/accounts/17035828/envelopes/#{envelope_id}",
        fn conn ->
          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.resp(200, envelope_status_response)
        end
      )

      {:ok, response} =
        DocuSign.Connection.request(conn,
          method: :get,
          url: "/v2.1/accounts/17035828/envelopes/#{envelope_id}"
        )

      assert response.status == 200
      assert response.body["envelopeId"] == envelope_id
      assert response.body["status"]
    end
  end

  describe "response body handling" do
    test "correctly handles string keys in response", %{bypass: bypass} do
      # Mock OAuth endpoints
      Bypass.stub(bypass, "POST", "/oauth/token", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(
          200,
          Jason.encode!(%{
            "access_token" => "test_token",
            "expires_in" => 3600,
            "token_type" => "Bearer"
          })
        )
      end)

      Bypass.stub(bypass, "GET", "/oauth/userinfo", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(
          200,
          Jason.encode!(%{
            "accounts" => [
              %{
                "account_id" => "12345",
                "base_uri" => "http://localhost:#{bypass.port}",
                "is_default" => true
              }
            ]
          })
        )
      end)

      {:ok, conn} = DocuSign.Connection.get("test_user_id")

      # Test that response body has string keys
      Bypass.expect_once(bypass, "GET", "/restapi/test", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(
          200,
          Jason.encode!(%{
            "arrayField" => [1, 2, 3],
            "nestedObject" => %{
              "innerKey" => "innerValue"
            },
            "stringKey" => "value"
          })
        )
      end)

      {:ok, response} =
        DocuSign.Connection.request(conn,
          method: :get,
          url: "/test"
        )

      # Verify response body has string keys (Req decodes JSON with string keys by default)
      assert response.body["stringKey"] == "value"
      assert response.body["nestedObject"]["innerKey"] == "innerValue"
      assert response.body["arrayField"] == [1, 2, 3]
    end
  end
end
