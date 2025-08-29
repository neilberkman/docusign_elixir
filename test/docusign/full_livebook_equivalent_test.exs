defmodule DocuSign.FullLivebookEquivalentTest do
  @moduledoc """
  This test runs the FULL EQUIVALENT of the embedded_signing.livemd Livebook.
  It uses REAL DocuSign API response formats to ensure backward compatibility.

  THIS IS WHAT SHOULD HAVE BEEN DONE FROM THE START!
  """
  use ExUnit.Case, async: false

  alias DocuSign.Api.EnvelopeDocuments
  alias DocuSign.Api.Envelopes
  alias DocuSign.Api.EnvelopeViews
  alias DocuSign.Connection

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "FULL Livebook equivalent test" do
    test "complete embedded signing flow with document download", %{bypass: bypass} do
      # This test simulates the EXACT flow from embedded_signing.livemd
      # using REAL DocuSign response formats

      # We're not testing JWT auth flow here - just the envelope operations
      # The connection is created directly with the needed configuration

      # 3. Mock envelope creation with REAL response format
      envelope_id = "test-envelope-#{:rand.uniform(1000)}"

      Bypass.expect_once(
        bypass,
        "POST",
        "/v2.1/accounts/test-account/envelopes",
        fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/json")
          |> Plug.Conn.resp(
            201,
            Jason.encode!(%{
              "envelopeId" => envelope_id,
              "status" => "sent",
              "statusDateTime" => "2024-01-01T00:00:00.0000000Z",
              "uri" => "/envelopes/#{envelope_id}"
            })
          )
        end
      )

      # 4. Mock recipient view (embedded signing URL) with REAL response format
      Bypass.expect_once(
        bypass,
        "POST",
        "/v2.1/accounts/test-account/envelopes/#{envelope_id}/views/recipient",
        fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/json")
          |> Plug.Conn.resp(
            201,
            Jason.encode!(%{
              "url" => "https://demo.docusign.net/Signing/StartInSession.aspx?t=test-token"
            })
          )
        end
      )

      # 5. Mock envelope status check with REAL response format
      Bypass.expect(
        bypass,
        "GET",
        "/v2.1/accounts/test-account/envelopes/#{envelope_id}",
        fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/json")
          |> Plug.Conn.resp(
            200,
            Jason.encode!(%{
              "completedDateTime" => "2024-01-01T00:01:00.0000000Z",
              "envelopeId" => envelope_id,
              "status" => "completed",
              "statusDateTime" => "2024-01-01T00:01:00.0000000Z"
            })
          )
        end
      )

      # 6. Mock document list with REAL response format
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2.1/accounts/test-account/envelopes/#{envelope_id}/documents",
        fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/json")
          |> Plug.Conn.resp(
            200,
            Jason.encode!(%{
              "envelopeDocuments" => [
                %{
                  "documentId" => "1",
                  "name" => "Example Document",
                  "order" => "1",
                  "pages" => "1",
                  "type" => "content",
                  "uri" => "/envelopes/#{envelope_id}/documents/1"
                },
                %{
                  "documentId" => "certificate",
                  "name" => "Summary",
                  "order" => "999",
                  "pages" => "2",
                  "type" => "summary",
                  "uri" => "/envelopes/#{envelope_id}/documents/certificate"
                }
              ],
              "envelopeId" => envelope_id
            })
          )
        end
      )

      # 7. THE CRITICAL PART - Mock document download with REAL DocuSign header format!
      # This is what the real DocuSign API returns - headers as lists in Req!
      # Using expect (not expect_once) because we test this twice
      Bypass.expect(
        bypass,
        "GET",
        "/v2.1/accounts/test-account/envelopes/#{envelope_id}/documents/1",
        fn conn ->
          pdf_content = "%PDF-1.5\n%Test PDF content from REAL API\n"

          conn
          |> Plug.Conn.put_resp_header("content-type", "application/pdf")
          |> Plug.Conn.put_resp_header(
            "content-disposition",
            ~s(file; filename="Embedded_Signing_Example.html.pdf"; documentid="1")
          )
          |> Plug.Conn.resp(200, pdf_content)
        end
      )

      # Now run the EXACT flow from the Livebook

      # Create connection (simulating JWT auth)
      conn = %Connection{
        req:
          Req.new(
            base_url: "http://localhost:#{bypass.port}",
            headers: [{"authorization", "Bearer fake_jwt_token"}]
          )
      }

      # Create envelope
      envelope_def = %{
        "documents" => [
          %{
            "documentBase64" => Base.encode64("Test document content"),
            "documentId" => "1",
            "fileExtension" => "pdf",
            "name" => "Test.pdf"
          }
        ],
        "emailSubject" => "Test Document",
        "recipients" => %{
          "signers" => [
            %{
              "clientUserId" => "test-client-123",
              "email" => "test@example.com",
              "name" => "Test Signer",
              "recipientId" => "1",
              "routingOrder" => "1"
            }
          ]
        },
        "status" => "sent"
      }

      {:ok, envelope_response} =
        Envelopes.envelopes_post_envelopes(
          conn,
          "test-account",
          body: envelope_def
        )

      assert envelope_response.envelopeId == envelope_id

      # Get embedded signing URL
      recipient_view_request = %{
        "authenticationMethod" => "none",
        "clientUserId" => "test-client-123",
        "email" => "test@example.com",
        "returnUrl" => "https://example.com/return",
        "userName" => "Test Signer"
      }

      {:ok, view_response} =
        EnvelopeViews.views_post_envelope_recipient_view(
          conn,
          "test-account",
          envelope_id,
          body: recipient_view_request
        )

      assert view_response.url =~ "StartInSession.aspx"

      # Check envelope status
      {:ok, status_response} =
        Envelopes.envelopes_get_envelope(
          conn,
          "test-account",
          envelope_id
        )

      assert status_response.status == "completed"

      # Get document list
      {:ok, docs_response} =
        EnvelopeDocuments.documents_get_documents(
          conn,
          "test-account",
          envelope_id
        )

      assert length(docs_response.envelopeDocuments) == 2

      # THE CRITICAL TEST - Download document using Connection.download_file
      # This MUST work exactly as it did in the Livebook with strategy: :memory!
      {:ok, {content, filename, content_type}} =
        Connection.download_file(
          conn,
          "/v2.1/accounts/test-account/envelopes/#{envelope_id}/documents/1",
          strategy: :memory
        )

      assert content == "%PDF-1.5\n%Test PDF content from REAL API\n"
      assert filename == "Embedded_Signing_Example.html.pdf"
      assert content_type == "application/pdf"

      # Also test with FileDownloader directly
      {:ok, {content2, filename2, content_type}} =
        DocuSign.FileDownloader.download_to_memory(
          conn,
          "/v2.1/accounts/test-account/envelopes/#{envelope_id}/documents/1"
        )

      assert content2 == "%PDF-1.5\n%Test PDF content from REAL API\n"
      assert filename2 == "Embedded_Signing_Example.html.pdf"
      assert content_type == "application/pdf"
    end

    test "handles all DocuSign header format variations", %{bypass: bypass} do
      # Test various REAL header formats DocuSign uses
      test_cases = [
        # Standard envelope document
        {~s(file; filename="Document.pdf"; documentid="1"), "Document.pdf"},
        # Combined documents
        {"inline; filename=\"Combined_Document.pdf\"", "Combined_Document.pdf"},
        # Certificate of completion
        {~s(file; filename="summary.pdf"; documentid="certificate"), "summary.pdf"},
        # With spaces in filename
        {~s(file; filename="My Document.pdf"; documentid="2"), "My Document.pdf"},
        # Attachment disposition
        {"attachment; filename=\"Contract.pdf\"", "Contract.pdf"}
      ]

      Enum.each(test_cases, fn {header_value, expected_filename} ->
        path = "/document/#{:rand.uniform(1000)}"

        Bypass.expect_once(bypass, "GET", path, fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/pdf")
          |> Plug.Conn.put_resp_header("content-disposition", header_value)
          |> Plug.Conn.resp(200, "%PDF-1.5\n%content\n")
        end)

        conn = %Connection{
          req: Req.new(base_url: "http://localhost:#{bypass.port}")
        }

        # Test Connection.download_file backward compatibility with memory strategy (as used in Livebook)
        {:ok, {_content, filename, _content_type}} =
          Connection.download_file(conn, path, strategy: :memory)

        assert filename == expected_filename

        # Reset for FileDownloader test
        Bypass.expect_once(bypass, "GET", path, fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/pdf")
          |> Plug.Conn.put_resp_header("content-disposition", header_value)
          |> Plug.Conn.resp(200, "%PDF-1.5\n%content\n")
        end)

        # Test FileDownloader
        {:ok, {_content, filename2, _type}} =
          DocuSign.FileDownloader.download_to_memory(conn, path)

        assert filename2 == expected_filename
      end)
    end
  end
end
