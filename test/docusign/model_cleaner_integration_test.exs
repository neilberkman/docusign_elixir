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

      result =
        DocuSign.RequestBuilder.add_optional_params(request, %{body: :body},
          body: envelope_definition
        )

      # Extract the cleaned body from the result
      cleaned_body = result.body

      # Verify it's a map (not a struct)
      assert is_map(cleaned_body)
      refute is_struct(cleaned_body)

      # Verify nil values were removed at various levels
      refute Map.has_key?(cleaned_body, :emailBlurb)

      # Check document
      document = List.first(cleaned_body.documents)
      refute Map.has_key?(document, :transformPdfFields)

      # Check nested tabs
      signer = List.first(cleaned_body.recipients.signers)
      sign_here = List.first(signer.tabs.signHereTabs)
      refute Map.has_key?(sign_here, :anchorYOffset)

      # Check removed nil lists/maps
      refute Map.has_key?(signer.tabs, :dateSignedTabs)
      refute Map.has_key?(cleaned_body.recipients, :carbonCopies)
    end
  end
end
