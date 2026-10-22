defmodule DocuSign.RequestBuilderTest do
  use ExUnit.Case

  alias DocuSign.Model.EnvelopeRecipientTabs
  alias DocuSign.Model.Text
  alias DocuSign.RequestBuilder

  describe "encode_path_param/1" do
    for {value, encoded} <- [
          {"plain-id_123.~", "plain-id_123.~"},
          {123, "123"},
          {"/", "%2F"},
          {"?", "%3F"},
          {"#", "%23"},
          {"%", "%25"},
          {" ", "%20"},
          {"café", "caf%C3%A9"},
          {".", "%2E"},
          {"..", "%2E%2E"},
          {"../x", "..%2Fx"}
        ] do
      test "encodes #{inspect(value)} as one path segment" do
        assert RequestBuilder.encode_path_param(unquote(value)) == unquote(encoded)
      end
    end
  end

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
      decoded = JSON.decode!(json_body)

      assert decoded == %{
               "textTabs" => [%{"tabId" => ":id:", "value" => ":value:"}]
             }
    end

    test "encodes a model nested inside a plain map" do
      body = %{"tab" => %Text{status: nil, tabId: ":id:", value: ":value:"}}

      assert JSON.decode!(JSON.encode!(body)) == %{
               "tab" => %{"tabId" => ":id:", "value" => ":value:"}
             }
    end

    test "encodes models used as map values" do
      body = %{
        "first" => %Text{status: nil, tabId: "1"},
        "second" => %Text{status: nil, value: "2"}
      }

      assert JSON.decode!(JSON.encode!(body)) == %{
               "first" => %{"tabId" => "1"},
               "second" => %{"value" => "2"}
             }
    end

    test "encodes an all-nil model as an empty object" do
      assert JSON.decode!(JSON.encode!(%Text{})) == %{}
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

      body_data = %{"test" => "data"}

      opts = [
        body: body_data,
        headers: %{"X-Custom-Header" => "custom-value"}
      ]

      result = RequestBuilder.add_optional_params(request, optional_params, opts)

      assert %{body: body, headers: headers} = result
      assert JSON.decode!(body) == body_data
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
