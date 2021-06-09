defmodule DocuSign.RequestBuilderTest do
  use ExUnit.Case

  alias DocuSign.RequestBuilder

  describe "adding optional params to request" do
    test "struct with nil values returns a map with nil values excluded" do
      request = %{}
      optional_params = %{
        EnvelopeRecipientTabs: :body
      }

      tab =  %DocuSign.Model.Text{tabId: ":id:", value: ":value:", status: nil}
      tabs = %DocuSign.Model.EnvelopeRecipientTabs{textTabs: [tab], approveTabs: nil}
      opts = [EnvelopeRecipientTabs: tabs]

      result = RequestBuilder.add_optional_params(request, optional_params, opts)

      assert result == %{body: %{textTabs: [%{tabId: ":id:", value: ":value:"}]}}
    end
  end
end
