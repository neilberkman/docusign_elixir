defmodule DocuSign.ModelCleanerIntegrationTest do
  use ExUnit.Case

  describe "integration with API calls" do
    test "ModelCleaner is applied to request bodies" do
      # Create test data with nested nil values
      envelope_definition = %DocuSign.Model.EnvelopeDefinition{
        emailSubject: "Test Subject",
        # This should be removed
        emailBlurb: nil,
        status: "created",
        documents: [
          %DocuSign.Model.Document{
            documentBase64: "base64content",
            name: "Test Document",
            fileExtension: "pdf",
            documentId: "1",
            # This should be removed
            transformPdfFields: nil
          }
        ],
        recipients: %DocuSign.Model.Recipients{
          signers: [
            %DocuSign.Model.Signer{
              email: "test@example.com",
              name: "Test Signer",
              recipientId: "1",
              routingOrder: "1",
              tabs: %DocuSign.Model.Tabs{
                signHereTabs: [
                  %DocuSign.Model.SignHere{
                    anchorString: "Sign Here",
                    anchorXOffset: "0",
                    # This should be removed
                    anchorYOffset: nil,
                    documentId: "1",
                    recipientId: "1"
                  }
                ],
                # This should be removed
                dateSignedTabs: nil
              }
            }
          ],
          # This should be removed
          carbonCopies: nil
        }
      }

      # Instead of testing the entire API call chain which involves Tesla client setup,
      # let's directly test the ModelCleaner integration in RequestBuilder
      request = %{}

      # Test both the body and named parameter paths

      # 1. Test with body parameter
      body_result =
        DocuSign.RequestBuilder.add_optional_params(request, %{body: :body},
          body: envelope_definition
        )

      # Extract the cleaned body
      body = body_result.body

      # For :body parameter, ModelCleaner returns a cleaned map, not a Tesla.Multipart
      assert is_map(body) and not is_struct(body)

      # Check that nil values were removed in the direct body
      refute Map.has_key?(body, :emailBlurb)
      document = List.first(body.documents)
      refute Map.has_key?(document, :transformPdfFields)
      signer = List.first(body.recipients.signers)
      sign_here = List.first(signer.tabs.signHereTabs)
      refute Map.has_key?(sign_here, :anchorYOffset)
      refute Map.has_key?(signer.tabs, :dateSignedTabs)
      refute Map.has_key?(body.recipients, :carbonCopies)

      # 2. Test with named parameter
      named_result =
        DocuSign.RequestBuilder.add_optional_params(request, %{envelope: :body},
          envelope: envelope_definition
        )

      # Extract and verify the body is now a Tesla.Multipart
      multipart = named_result.body
      assert %Tesla.Multipart{parts: [part]} = multipart
      assert %Tesla.Multipart.Part{body: json_body} = part

      # Parse the JSON
      decoded = Jason.decode!(json_body)

      # Verify nil values were removed at various levels
      refute Map.has_key?(decoded, "emailBlurb")

      # Check document
      document = List.first(decoded["documents"])
      refute Map.has_key?(document, "transformPdfFields")

      # Check nested tabs
      signer = List.first(decoded["recipients"]["signers"])
      sign_here = List.first(signer["tabs"]["signHereTabs"])
      refute Map.has_key?(sign_here, "anchorYOffset")

      # Check removed nil lists/maps
      refute Map.has_key?(signer["tabs"], "dateSignedTabs")
      refute Map.has_key?(decoded["recipients"], "carbonCopies")
    end
  end
end
