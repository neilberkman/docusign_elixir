defmodule DocuSign.RequestBuilderTest do
  use ExUnit.Case

  alias DocuSign.RequestBuilder

  describe "adding optional params to request" do
    test "struct with nil values returns a map with nil values excluded" do
      request = %{}

      optional_params = %{
        EnvelopeRecipientTabs: :body
      }

      tab = %DocuSign.Model.Text{tabId: ":id:", value: ":value:", status: nil}
      tabs = %DocuSign.Model.EnvelopeRecipientTabs{textTabs: [tab], approveTabs: nil}
      opts = [EnvelopeRecipientTabs: tabs]

      result = RequestBuilder.add_optional_params(request, optional_params, opts)

      # With Tesla.Multipart, we can't directly compare the entire structure
      # So instead we extract and verify the JSON content
      assert %{body: %Tesla.Multipart{parts: [part]}} = result
      assert %Tesla.Multipart.Part{body: json_body} = part

      # Parse the JSON body and check the structure
      decoded = Jason.decode!(json_body)
      assert %{"textTabs" => [%{"tabId" => ":id:", "value" => ":value:"}]} = decoded

      # Check that nil values were removed
      refute Map.has_key?(decoded, "approveTabs")
    end
  end
end
