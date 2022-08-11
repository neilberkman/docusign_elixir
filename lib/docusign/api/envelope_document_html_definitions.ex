# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Api.EnvelopeDocumentHtmlDefinitions do
  @moduledoc """
  API calls for all endpoints tagged `EnvelopeDocumentHtmlDefinitions`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder


  @doc """
  Gets the Original HTML Definition used to generate the Responsive HTML for a given document.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - document_id (String.t): The unique ID of the document within the envelope.  Unlike other IDs in the eSignature API, you specify the `documentId` yourself. Typically the first document has the ID `1`, the second document `2`, and so on, but you can use any numbering scheme that fits within a 32-bit signed integer (1 through 2147483647).   Tab objects have a `documentId` property that specifies the document on which to place the tab. 
  - envelope_id (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, DocuSign.Model.DocumentHtmlDefinitionOriginals.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec responsive_html_get_envelope_document_html_definitions(Tesla.Env.client, String.t, String.t, String.t, keyword()) :: {:ok, DocuSign.Model.DocumentHtmlDefinitionOriginals.t} | {:ok, DocuSign.Model.ErrorDetails.t} | {:error, Tesla.Env.t}
  def responsive_html_get_envelope_document_html_definitions(connection, account_id, document_id, envelope_id, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/documents/#{document_id}/html_definitions")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 200, %DocuSign.Model.DocumentHtmlDefinitionOriginals{}},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end