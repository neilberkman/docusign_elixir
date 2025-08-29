defmodule DocuSign.ApiResponseTest do
  use ExUnit.Case, async: true

  alias DocuSign.Api.Envelopes
  alias DocuSign.Model.EnvelopeDefinition
  alias DocuSign.Model.EnvelopeSummary

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "real API response handling" do
    test "handles real create envelope response", %{bypass: bypass} do
      # Load real response fixture
      real_response = File.read!("test/fixtures/api_responses/create_envelope_201.json")

      Bypass.expect_once(bypass, "POST", "/envelopes", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(201, real_response)
      end)

      # Create a test connection pointing to our bypass server
      req =
        Req.new(
          base_url: "http://localhost:#{bypass.port}",
          headers: [
            {"authorization", "Bearer test_token"},
            {"content-type", "application/json"}
          ]
        )

      conn = %DocuSign.Connection{
        app_account: %{base_uri: "http://localhost:#{bypass.port}"},
        client: %OAuth2.Client{
          token: %OAuth2.AccessToken{
            access_token: "test_token",
            token_type: "Bearer"
          }
        },
        req: req
      }

      # Make request
      {:ok, response} =
        DocuSign.Connection.request(conn,
          method: :post,
          url: "/envelopes",
          json: %{"test" => "data"}
        )

      # Verify response parsing works correctly
      assert response.status == 201
      assert response.body["envelopeId"] == "b24e6c1c-4269-4098-a84d-06d4c072a915"
      assert response.body["status"] == "sent"
      assert response.body["statusDateTime"] == "2025-08-31T22:01:23.9770000Z"
      assert response.body["uri"] == "/envelopes/b24e6c1c-4269-4098-a84d-06d4c072a915"
    end

    test "handles real recipient view response", %{bypass: bypass} do
      # Load real response fixture
      real_response = File.read!("test/fixtures/api_responses/recipient_view_201.json")

      Bypass.expect_once(bypass, "POST", "/views/recipient", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(201, real_response)
      end)

      req =
        Req.new(
          base_url: "http://localhost:#{bypass.port}",
          headers: [
            {"authorization", "Bearer test_token"},
            {"content-type", "application/json"}
          ]
        )

      conn = %DocuSign.Connection{
        app_account: %{base_uri: "http://localhost:#{bypass.port}"},
        client: %OAuth2.Client{
          token: %OAuth2.AccessToken{
            access_token: "test_token",
            token_type: "Bearer"
          }
        },
        req: req
      }

      {:ok, response} =
        DocuSign.Connection.request(conn,
          method: :post,
          url: "/views/recipient",
          json: %{"test" => "data"}
        )

      # Verify response parsing
      assert response.status == 201
      assert response.body["url"]
      assert String.starts_with?(response.body["url"], "https://demo.docusign.net/Signing/")
    end

    test "handles real envelope status response", %{bypass: bypass} do
      # Load real response fixture
      real_response = File.read!("test/fixtures/api_responses/envelope_status_200.json")

      Bypass.expect_once(bypass, "GET", "/envelopes/test-id", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, real_response)
      end)

      req =
        Req.new(
          base_url: "http://localhost:#{bypass.port}",
          headers: [
            {"authorization", "Bearer test_token"},
            {"content-type", "application/json"}
          ]
        )

      conn = %DocuSign.Connection{
        app_account: %{base_uri: "http://localhost:#{bypass.port}"},
        client: %OAuth2.Client{
          token: %OAuth2.AccessToken{
            access_token: "test_token",
            token_type: "Bearer"
          }
        },
        req: req
      }

      {:ok, response} =
        DocuSign.Connection.request(conn,
          method: :get,
          url: "/envelopes/test-id"
        )

      # Verify complex nested response parsing
      assert response.status == 200
      assert response.body["envelopeId"] == "b24e6c1c-4269-4098-a84d-06d4c072a915"
      assert response.body["status"] == "sent"
      assert response.body["emailSubject"] == "Test Document for Response Capture"

      # Check nested objects
      assert response.body["sender"]["email"] == "neil@xuku.com"
      assert response.body["sender"]["userId"] == "3082b430-1a94-470c-839b-6b9e6f4b7c81"
      assert response.body["envelopeMetadata"]["allowCorrect"] == "true"

      # Check various field types
      assert response.body["allowViewHistory"] == "true"
      assert response.body["anySigner"] == nil
      assert response.body["expireAfter"] == "120"
    end

    test "verifies Req auto-decodes JSON with string keys", %{bypass: bypass} do
      # Create a response with various data types
      json_response =
        Jason.encode!(%{
          "array" => [1, 2, 3],
          "boolean" => true,
          "float" => 3.14,
          "nested" => %{
            "deep" => %{
              "key" => "value"
            }
          },
          "null" => nil,
          "number" => 42,
          "string" => "value"
        })

      Bypass.expect_once(bypass, "GET", "/test", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, json_response)
      end)

      req =
        Req.new(
          base_url: "http://localhost:#{bypass.port}",
          headers: [{"authorization", "Bearer test"}]
        )

      conn = %DocuSign.Connection{
        app_account: %{base_uri: "http://localhost:#{bypass.port}"},
        client: %OAuth2.Client{
          token: %OAuth2.AccessToken{
            access_token: "test",
            token_type: "Bearer"
          }
        },
        req: req
      }

      {:ok, response} =
        DocuSign.Connection.request(conn,
          method: :get,
          url: "/test"
        )

      # Req automatically decodes JSON and uses string keys
      assert response.body["string"] == "value"
      assert response.body["number"] == 42
      assert response.body["float"] == 3.14
      assert response.body["boolean"] == true
      assert response.body["null"] == nil
      assert response.body["array"] == [1, 2, 3]
      assert response.body["nested"]["deep"]["key"] == "value"

      # Should NOT have atom keys
      refute Map.has_key?(response.body, :string)
      refute Map.has_key?(response.body, :number)
    end
  end

  describe "API method integration" do
    test "EnvelopeSummary model decoding with real response", %{bypass: bypass} do
      # Use the real create envelope response
      real_response = File.read!("test/fixtures/api_responses/create_envelope_201.json")

      Bypass.expect_once(bypass, "POST", "/v2.1/accounts/123/envelopes", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(201, real_response)
      end)

      req =
        Req.new(
          base_url: "http://localhost:#{bypass.port}",
          headers: [
            {"authorization", "Bearer test_token"},
            {"content-type", "application/json"}
          ]
        )

      conn = %DocuSign.Connection{
        app_account: %{base_uri: "http://localhost:#{bypass.port}"},
        client: %OAuth2.Client{
          token: %OAuth2.AccessToken{
            access_token: "test_token",
            token_type: "Bearer"
          }
        },
        req: req
      }

      # Call the actual API method
      envelope_definition = %EnvelopeDefinition{
        emailSubject: "Test",
        status: "sent"
      }

      {:ok, envelope_summary} =
        Envelopes.envelopes_post_envelopes(
          conn,
          "123",
          envelope_definition: envelope_definition
        )

      # Verify it returns the correct model type with data
      assert %EnvelopeSummary{} = envelope_summary
      assert envelope_summary.envelopeId == "b24e6c1c-4269-4098-a84d-06d4c072a915"
      assert envelope_summary.status == "sent"
      assert envelope_summary.statusDateTime == "2025-08-31T22:01:23.9770000Z"
      assert envelope_summary.uri == "/envelopes/b24e6c1c-4269-4098-a84d-06d4c072a915"
    end
  end
end
