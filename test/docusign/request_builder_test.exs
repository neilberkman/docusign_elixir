defmodule DocuSign.RequestBuilderTest do
  use ExUnit.Case

  alias DocuSign.Model.EnvelopeRecipientTabs
  alias DocuSign.Model.Text
  alias DocuSign.RequestBuilder

  describe "adding optional params to request" do
    test "struct with nil values returns a map with nil values excluded" do
      request = %{}

      optional_params = %{
        EnvelopeRecipientTabs: :body
      }

      tab = %Text{status: nil, tabId: ":id:", value: ":value:"}
      tabs = %EnvelopeRecipientTabs{approveTabs: nil, textTabs: [tab]}
      opts = [EnvelopeRecipientTabs: tabs]

      result = RequestBuilder.add_optional_params(request, optional_params, opts)

      assert %{form_multipart: [part]} = result
      assert {"EnvelopeRecipientTabs", json_body, [content_type: "application/json"]} = part

      # Parse the JSON body and check the structure
      decoded = Jason.decode!(json_body)
      assert %{"textTabs" => [%{"tabId" => ":id:", "value" => ":value:"}]} = decoded

      # Check that nil values were removed
      refute Map.has_key?(decoded, "approveTabs")
    end
  end

  describe "custom headers support" do
    test "adds custom headers to request" do
      request = %{}
      optional_params = %{}

      opts = [
        headers: %{
          "X-DocuSign-Edit" => ~s({"LockToken": "abc123", "LockDurationInSeconds": "600"})
        }
      ]

      result = RequestBuilder.add_optional_params(request, optional_params, opts)

      assert %{headers: headers} = result
      assert {"X-DocuSign-Edit", ~s({"LockToken": "abc123", "LockDurationInSeconds": "600"})} in headers
    end

    test "merges custom headers with existing headers" do
      request = %{headers: [{"existing-header", "existing-value"}]}
      optional_params = %{}

      opts = [
        headers: %{
          "X-DocuSign-Edit" => ~s({"LockToken": "token123"})
        }
      ]

      result = RequestBuilder.add_optional_params(request, optional_params, opts)

      assert %{headers: headers} = result
      assert {"X-DocuSign-Edit", ~s({"LockToken": "token123"})} in headers
      assert {"existing-header", "existing-value"} in headers
    end

    test "supports multiple custom headers" do
      request = %{}
      optional_params = %{}

      opts = [
        headers: %{
          "X-Another-Header" => "value3",
          "X-Custom-Header" => "value2",
          "X-DocuSign-Edit" => "value1"
        }
      ]

      result = RequestBuilder.add_optional_params(request, optional_params, opts)

      assert %{headers: headers} = result
      assert {"X-DocuSign-Edit", "value1"} in headers
      assert {"X-Custom-Header", "value2"} in headers
      assert {"X-Another-Header", "value3"} in headers
    end

    test "works alongside other optional params" do
      request = %{}
      optional_params = %{body: :body}

      body_data = %{test: "data"}

      opts = [
        body: body_data,
        headers: %{"X-Custom-Header" => "custom-value"}
      ]

      result = RequestBuilder.add_optional_params(request, optional_params, opts)

      assert %{body: body, headers: headers} = result
      assert body == Jason.encode!(body_data)
      assert {"X-Custom-Header", "custom-value"} in headers
    end

    test "ignores headers option if not a map" do
      request = %{}
      optional_params = %{}

      opts = [
        headers: "invalid-not-a-map"
      ]

      # Should not crash, just ignore the invalid headers
      result = RequestBuilder.add_optional_params(request, optional_params, opts)

      # Should not have added any headers
      refute Map.has_key?(result, :headers)
    end
  end
end
