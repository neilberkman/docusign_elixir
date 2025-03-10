# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.EnvelopeDocuments do
  @moduledoc """
  API calls for all endpoints tagged `EnvelopeDocuments`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes documents from a draft envelope.
  Deletes one or more documents from an existing envelope that has not yet been completed.  To delete a document, use only the relevant parts of the [`envelopeDefinition`](#envelopeDefinition). For example, this request body specifies that you want to delete the document whose `documentId` is \"1\".   ```text {   \"documents\": [     {       \"documentId\": \"1\"     }   ] } ```  The envelope status must be one of:  - `created` - `sent` - `delivered`   

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:body` (EnvelopeDefinition): 

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeDocumentsResult.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec documents_delete_documents(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.EnvelopeDocumentsResult.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def documents_delete_documents(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/documents")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EnvelopeDocumentsResult},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Retrieves a single document or all documents from an envelope.
  Retrieves a single document or all documents from an envelope.  To retrieve a single document, provide the ID of the document in the `documentId` path parameter. Alternatively, by setting the `documentId` parameter to special keyword values, you can retrieve all the documents (as a combined PDF, portfolio PDF, or ZIP archive) or just the certificate of completion. See the `documentId` description for how to retrieve each format.   The response body of this method is a file. If you request multiple documents, the result is a ZIP archive that contains all of the documents.  In all other cases, the response is a PDF file or PDF portfolio.   You can get the file name and document ID from the response's `Content-Disposition` header:  ``` Content-Disposition: file; filename=\"NDA.pdf\"; documentid=\"1 ```  By default, the response is the PDF file as a byte stream. For example a request/response in `curl` looks like this:  ``` $ curl --request GET 'https://demo.docusign.net/restapi/v2/accounts/0cdb3ff3-xxxx-xxxx-xxxx-e43af011006d/envelopes/ea4cc25b-xxxx-xxxx-xxxx-a67a0a2a4f6c/documents/1/' \\        --header 'Authorization: Bearer eyJ...bqg'   HTTP/1.1 200 OK Content-Length: 167539 Content-Type: application/pdf . . . Content-Disposition: file; filename=\"Lorem_Ipsum.pdf\"; documentid=\"1\" Date: Tue, 23 Aug 2022 01:13:15 GMT  %PDF-1.4 %˚¸˝˛ 6 0 obj <</Length 14>>stream . . . ```  By using the `Content-Transfer-Encoding` header in the request, you can obtain the PDF file encoded in base64. The same `curl` request with the base64 header would look like this:  ``` $ curl --request GET 'https://demo.docusign.net/restapi/v2/accounts/0cdb3ff3-xxxx-xxxx-xxxx-e43af011006d/envelopes/ea4cc25b-xxxx-xxxx-xxxx-a67a0a2a4f6c/documents/1/' \\        --header 'Authorization: Bearer eyJ...bqg' \\        --header 'Content-Transfer-Encoding: base64'   HTTP/1.1 200 OK Content-Length: 223384 Content-Type: application/pdf . . . Content-Disposition: file; filename=\"Lorem_Ipsum.pdf\"; documentid=\"1\" Content-Transfer-Encoding: base64 Date: Tue, 23 Aug 2022 01:12:30 GMT  JVBERi0xLjQKJfv8/f4KNiAwIG9iago8PC9MZW. . .== ```   (In an actual `curl` request you would use the `--output` switch to save the byte stream into a file.)  ### Related topics  - [How to download envelope documents](/docs/esign-rest-api/how-to/download-envelope-documents/) 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `document_id` (String.t): The ID of the document to retrieve. Alternatively, you can use one of the following special keywords:  - `combined`: Retrieves all of the documents as a single PDF file.   When the query parameter `certificate` is **true,** the certificate of completion is included in the PDF file.   When the query parameter `certificate` is **false,** the certificate of completion is not included in the PDF file. - `archive`: Retrieves a ZIP archive that contains all of the PDF documents and the certificate of completion. - `certificate`: Retrieves only the certificate of completion as a PDF file. - `portfolio`: Retrieves the envelope documents as a [PDF portfolio](https://helpx.adobe.com/acrobat/using/overview-pdf-portfolios.html).
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:certificate` (String.t): Used only when the `documentId` parameter is the special keyword `combined`.  When **true,** the certificate of completion is included in the combined PDF file. When **false,** (the default) the certificate of completion is not included in the combined PDF file.  
    - `:documents_by_userid` (String.t): When **true,** allows recipients to get documents by their user id. For example, if a user is included in two different routing orders with different visibilities, using this parameter returns all of the documents from both routing orders.
    - `:encoding` (String.t): Reserved for Docusign.
    - `:encrypt` (String.t): When **true,** the PDF bytes returned in the response are encrypted for all the key managers configured on your Docusign account. You can decrypt the documents by using the Key Manager DecryptDocument API method. For more information about Key Manager, see the Docusign Security Appliance Installation Guide that your organization received from Docusign.
    - `:language` (String.t): Specifies the language for the Certificate of Completion in the response. The supported languages are: Chinese Simplified (zh_CN), Chinese Traditional (zh_TW), Dutch (nl), English US (en), French (fr), German (de), Italian (it), Japanese (ja), Korean (ko), Portuguese (pt), Portuguese (Brazil) (pt_BR), Russian (ru), Spanish (es). 
    - `:recipient_id` (String.t): Allows the sender to retrieve the documents as one of the recipients that they control. The `documents_by_userid` parameter must be set to **false** for this functionality to work.
    - `:shared_user_id` (String.t): The ID of a shared user that you want to impersonate in order to retrieve their view of the list of documents. This parameter is used in the context of a shared inbox (i.e., when you share envelopes from one user to another through the Docusign Admin console).
    - `:show_changes` (String.t): When **true,** any changed fields for the returned PDF are highlighted in yellow and optional signatures or initials outlined in red. The account must have the **Highlight Data Changes** feature enabled.
    - `:watermark` (String.t): When **true,** the account has the watermark feature enabled, and the envelope is not complete, then the watermark for the account is added to the PDF documents. This option can remove the watermark. 

  ### Returns

  - `{:ok, String.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec documents_get_document(Tesla.Env.client(), String.t(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()} | {:ok, String.t()} | {:error, Tesla.Env.t()}
  def documents_get_document(connection, account_id, document_id, envelope_id, opts \\ []) do
    optional_params = %{
      :certificate => :query,
      :documents_by_userid => :query,
      :encoding => :query,
      :encrypt => :query,
      :language => :query,
      :recipient_id => :query,
      :shared_user_id => :query,
      :show_changes => :query,
      :watermark => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/documents/#{document_id}")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Gets a list of documents in an envelope.
  Retrieves a list of documents associated with the specified envelope.  ### Related topics  - [How to list envelope documents](/docs/esign-rest-api/how-to/list-envelope-documents/) 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:documents_by_userid` (String.t): When **true,** allows recipients to get documents by their user id. For example, if a user is included in two different routing orders with different visibilities, using this parameter returns all of the documents from both routing orders.
    - `:include_docgen_formfields` (String.t): Reserved for Docusign.
    - `:include_metadata` (String.t): When **true,** the response includes metadata that indicates which properties the sender can edit.
    - `:include_tabs` (String.t): Reserved for Docusign.
    - `:recipient_id` (String.t): Allows the sender to retrieve the documents as one of the recipients that they control. The `documents_by_userid` parameter must be set to **false** for this to work.
    - `:shared_user_id` (String.t): The ID of a shared user that you want to impersonate in order to retrieve their view of the list of documents. This parameter is used in the context of a shared inbox (i.e., when you share envelopes from one user to another through the Docusign Admin console).

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeDocumentsResult.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec documents_get_documents(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.EnvelopeDocumentsResult.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def documents_get_documents(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :documents_by_userid => :query,
      :include_docgen_formfields => :query,
      :include_metadata => :query,
      :include_tabs => :query,
      :recipient_id => :query,
      :shared_user_id => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/documents")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EnvelopeDocumentsResult},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Adds or replaces a document in an existing envelope.
  Adds or replaces a document in an existing draft or in-process envelope. An in-process envelope is one that has been sent but not yet completed or voided.   **Note:** When adding or modifying documents for an in-process envelope, Docusign recommends [locking the envelope](/docs/esign-rest-api/reference/envelopes/envelopelocks/create/) prior to making any changes.  To add a new document, set the `documentId` path parameter to a new document ID.  To replace a document, set the `documentId` path parameter to the document ID of the existing document. The tabs of the original document will be applied to the new document. For example, a request in cURL looks like this:  ``` $ curl --location --request PUT 'https://demo.docusign.net/restapi/v2.1/accounts/0cdb3ff3-xxxx-xxxx-xxxx-e43af011006d/envelopes/ea4cc25b-xxxx-xxxx-xxxx-a67a0a2a4f6c/documents/1' \\     --header 'Authorization: Bearer eyJ...bqg' \\     --header 'Content-Disposition: filename=\"newDocument\"' \\     --header 'Content-Type: application/pdf' \\     --data-binary '@/location/of/document.pdf' ```   <ds-inlinemessage kind=\"warning\"> If HTML document files contain <code>&lt;img&gt;</code> elements with the <code>src</code> attribute set to a path or URL, those images will not be displayed. Images in HTML files must be encoded in Base64 format, like this:<br/> <code>&lt;img src=\"data:image/gif;base64,R0lGODlh...IQAAOw==\" alt=\"Base64 encoded image\" width=\"150\" height=\"150\"/&gt;</code> </ds-inlinemessage>

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `document_id` (String.t): The unique ID of the document within the envelope.  Unlike other IDs in the eSignature API, you specify the `documentId` yourself. Typically the first document has the ID `1`, the second document `2`, and so on, but you can use any numbering scheme that fits within a 32-bit signed integer (1 through 2147483647).   Tab objects have a `documentId` property that specifies the document on which to place the tab. 
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `document_file_bytes` (String.t): Updated document content.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeDocument.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec documents_put_document(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.EnvelopeDocument.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def documents_put_document(
        connection,
        account_id,
        document_id,
        envelope_id,
        document_file_bytes,
        _opts \\ []
      ) do
    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/documents/#{document_id}")
      |> add_param(:body, :body, document_file_bytes)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EnvelopeDocument},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Adds one or more documents to an existing envelope.
  Adds one or more documents to an existing envelope. The tabs of the original document will be applied to the new document.   **Note:** When adding or modifying documents for an in-process envelope, Docusign recommends [locking the envelope](/docs/esign-rest-api/reference/envelopes/envelopelocks/create/) prior to making any changes.  If the file name of a document contains Unicode characters, you need to include a `Content-Disposition` header. Example:   **Header:** `Content-Disposition`   **Value:** `file; filename=\\\"name\\\";fileExtension=ext;documentId=1`  **Note:** This method works on documents only. To add recipient or document tabs, use methods from the [EnvelopeRecipientTabs](/docs/esign-rest-api/reference/envelopes/enveloperecipienttabs/) resource.  <ds-inlinemessage kind=\"warning\"> If HTML document files contain <code>&lt;img&gt;</code> elements with the <code>src</code> attribute set to a path or URL, those images will not be displayed. Images in HTML files must be encoded in Base64 format, like this:<br/> <code>&lt;img src=\"data:image/gif;base64,R0lGODlh...IQAAOw==\" alt=\"Base64 encoded image\" width=\"150\" height=\"150\"/&gt;</code> </ds-inlinemessage>  

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:body` (EnvelopeDefinition): 

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeDocumentsResult.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec documents_put_documents(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.EnvelopeDocumentsResult.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def documents_put_documents(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/documents")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EnvelopeDocumentsResult},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end
end
