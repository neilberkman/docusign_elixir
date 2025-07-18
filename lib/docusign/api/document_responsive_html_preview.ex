# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.DocumentResponsiveHtmlPreview do
  @moduledoc """
  API calls for all endpoints tagged `DocumentResponsiveHtmlPreview`.
  """

  import DocuSign.RequestBuilder

  alias DocuSign.Connection
  alias DocuSign.Model.DocumentHtmlDefinitions
  alias DocuSign.Model.ErrorDetails

  @doc """
  Creates a preview of the responsive version of a document.
  Creates a preview of the [responsive](/docs/esign-rest-api/esign101/concepts/responsive/) HTML version of a specific document. This method enables you to preview a PDF document conversion to responsive HTML across device types prior to sending.  The request body is a `documentHtmlDefinition` object, which holds the responsive signing parameters that define how to generate the HTML version of the signing document.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `document_id` (String.t): The unique ID of the document within the envelope.  Unlike other IDs in the eSignature API, you specify the `documentId` yourself. Typically the first document has the ID `1`, the second document `2`, and so on, but you can use any numbering scheme that fits within a 32-bit signed integer (1 through 2147483647).   Tab objects have a `documentId` property that specifies the document on which to place the tab.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec`
  - `opts` (keyword): Optional parameters
    - `:body` (DocumentHtmlDefinition):

  ### Returns

  - `{:ok, DocuSign.Model.DocumentHtmlDefinitions.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec responsive_html_post_document_responsive_html_preview(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, ErrorDetails.t()}
          | {:ok, DocumentHtmlDefinitions.t()}
          | {:error, Tesla.Env.t()}
  def responsive_html_post_document_responsive_html_preview(
        connection,
        account_id,
        document_id,
        envelope_id,
        opts \\ []
      ) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/documents/#{document_id}/responsive_html_preview")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, DocumentHtmlDefinitions},
      {400, ErrorDetails}
    ])
  end
end
