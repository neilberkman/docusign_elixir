# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.EnvelopeDocumentHtmlDefinitions do
  @moduledoc """
  API calls for all endpoints tagged `EnvelopeDocumentHtmlDefinitions`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Retrieves the HTML definition used to generate a dynamically sized responsive document.
  Retrieves the HTML definition used to generate a dynamically sized responsive document.  If the document was not created as a signable HTML document, this endpoint will return a 200-OK response and an empty JSON body.   **Note:** The `documentId` query parameter is a GUID value, not an integer document ID. If an invalid document ID is provided, this endpoint will return a 200-OK response and an empty JSON body.  ### Related topics  - [Responsive signing](/docs/esign-rest-api/esign101/concepts/responsive/)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `document_id` (String.t): The GUID of the document.  Example: c671747c-xxxx-xxxx-xxxx-4a4a48e23744
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.DocumentHtmlDefinitionOriginals.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec responsive_html_get_envelope_document_html_definitions(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.DocumentHtmlDefinitionOriginals.t()}
          | {:error, Tesla.Env.t()}
  def responsive_html_get_envelope_document_html_definitions(
        connection,
        account_id,
        document_id,
        envelope_id,
        _opts \\ []
      ) do
    request =
      %{}
      |> method(:get)
      |> url(
        "/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/documents/#{document_id}/html_definitions"
      )
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.DocumentHtmlDefinitionOriginals},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end
end
