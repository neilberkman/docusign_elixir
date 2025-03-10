# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.EnvelopeRecipients do
  @moduledoc """
  API calls for all endpoints tagged `EnvelopeRecipients`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes a recipient from an envelope.
  Deletes a recipient from a `draft` or `sent` envelope.  If the envelope is \"In Process\" (has been sent and is not completed or voided), recipients that have completed their actions cannot be deleted.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `recipient_id` (String.t): A local reference used to map recipients to other objects, such as specific document tabs.  A `recipientId` must be either an integer or a GUID, and the `recipientId` must be unique within an envelope.  For example, many envelopes assign the first recipient a `recipientId` of `1`. 
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeRecipients.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_delete_recipient(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.EnvelopeRecipients.t()}
          | {:error, Tesla.Env.t()}
  def recipients_delete_recipient(connection, account_id, envelope_id, recipient_id, _opts \\ []) do
    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/recipients/#{recipient_id}")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EnvelopeRecipients},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Deletes recipients from an envelope.
  Deletes one or more recipients from a draft or sent envelope. List the recipients that you want to delete in the body of the request. This method uses the `recipientId` as the key for deleting recipients.  If the envelope is `In Process`, meaning that it has been sent and has not been completed or voided, recipients that have completed their actions cannot be deleted.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:body` (EnvelopeRecipients): 

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeRecipients.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_delete_recipients(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.EnvelopeRecipients.t()}
          | {:error, Tesla.Env.t()}
  def recipients_delete_recipients(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/recipients")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EnvelopeRecipients},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Gets the status of recipients for an envelope.
  Retrieves the status of all recipients in a single envelope and identifies the current recipient in the routing list. This method can also be used to retrieve the tab values.  The `currentRoutingOrder` property of the response contains the `routingOrder` value of the current recipient indicating that the envelope has been sent to the recipient, but the recipient has not completed their actions.  ### Related topics  - [How to list envelope recipients](/docs/esign-rest-api/how-to/get-envelope-recipients/) - [How to retrieve ID Evidence events](/docs/idevidence-api/how-to/retrieve-idevidence-events/) - [How to retrieve ID Evidence media](/docs/idevidence-api/how-to/retrieve-idevidence-media/) 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:include_anchor_tab_locations` (String.t):  When **true** and `include_tabs` value is set to **true,** all tabs with anchor tab properties are included in the response. 
    - `:include_extended` (String.t):  When **true,** the extended properties are included in the response. 
    - `:include_metadata` (String.t): Boolean value that specifies whether to include metadata associated with the recipients (for envelopes only, not templates).
    - `:include_tabs` (String.t): When **true,** the tab information associated with the recipient is included in the response.

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeRecipients.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_get_recipients(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.EnvelopeRecipients.t()}
          | {:error, Tesla.Env.t()}
  def recipients_get_recipients(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :include_anchor_tab_locations => :query,
      :include_extended => :query,
      :include_metadata => :query,
      :include_tabs => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/recipients")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EnvelopeRecipients},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Creates a resource token for a sender to request ID Evidence data. 
  Creates a resource token for a sender. This token allows a sender to return identification data for a recipient using the [ID Evidence API](/docs/idevidence-api/).  ### Related topics  - [How to retrieve ID Evidence events](/docs/idevidence-api/how-to/retrieve-idevidence-events/) - [How to retrieve ID Evidence media](/docs/idevidence-api/how-to/retrieve-idevidence-media/)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The account ID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `recipient_id` (String.t): The `recipientIdGuid`.
  - `opts` (keyword): Optional parameters
    - `:token_scopes` (String.t): 

  ### Returns

  - `{:ok, DocuSign.Model.IdEvidenceResourceToken.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_post_recipient_proof_file_resource_token(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.IdEvidenceResourceToken.t()}
          | {:error, Tesla.Env.t()}
  def recipients_post_recipient_proof_file_resource_token(
        connection,
        account_id,
        envelope_id,
        recipient_id,
        opts \\ []
      ) do
    optional_params = %{
      :token_scopes => :query
    }

    request =
      %{}
      |> method(:post)
      |> url(
        "/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/recipients/#{recipient_id}/identity_proof_token"
      )
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, DocuSign.Model.IdEvidenceResourceToken},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Adds one or more recipients to an envelope.
  Adds one or more recipients to an envelope.  For an in-process envelope, one that has been sent and has not been completed or voided, an email is sent to a new recipient when they are reached in the routing order. If the new recipient's routing order is before or the same as the envelope's next recipient, an email is only sent if the optional `resend_envelope` query string is set to **true.**   **Note:** This method works on recipients only. To add recipient tabs, use methods from the [EnvelopeRecipientTabs][recipientTabs] resource. For example, this request body will add a recipient (`astanton@example.com`) but **NOT** the Sign Here recipient tab.  ```json {   \"signers\": [     {       \"email\": \"astanton@example.com\",       \"name\": \"Anne Stanton\",       \"recipientId\": \"1\",       \"tabs\": {           // These tabs will NOT be added         \"signHereTabs\": [ // with this method. See note above.           {             \"anchorString\": \"below\",             \"tooltip\": \"please sign here\"           },           . . .         ]       }     }   ] } ```  [recipientTabs]: /docs/esign-rest-api/reference/envelopes/enveloperecipienttabs/   ### Related topics  - [How to bulk send envelopes](/docs/esign-rest-api/how-to/bulk-send-envelopes/) - [How to request a signature by email](/docs/esign-rest-api/how-to/request-signature-email-remote/) - [How to request a signature through your app](/docs/esign-rest-api/how-to/request-signature-in-app-embedded/)    

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:resend_envelope` (String.t): When **true,** forces the envelope to be resent if it would not be resent otherwise.  Ordinarily, if the recipient's routing order is before or the same as the envelope's next recipient, the envelope is not resent.  Setting this query parameter to **false** has no effect and is the same as omitting it altogether. 
    - `:body` (EnvelopeRecipients): 

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeRecipients.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_post_recipients(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.EnvelopeRecipients.t()}
          | {:error, Tesla.Env.t()}
  def recipients_post_recipients(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :resend_envelope => :query,
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/recipients")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, DocuSign.Model.EnvelopeRecipients},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Updates recipients in a draft envelope or corrects recipient information for an in-process envelope.
  Updates the recipients of a draft envelope or corrects recipient information for an in-process envelope.  If you send information for a recipient that does not already exist in a draft envelope, the recipient is added to the envelope (similar to the [EnvelopeRecipients: Create][EnvelopeRecipients-create] method).  You can also use this method to resend an envelope to a recipient by using the `resend_envelope` option.  **Updating Sent Envelopes**  After an envelope has been sent, you can edit only the following properties:  - `accessCode` - `agentCanEditName` - `agentCanEditEmail` - `customFields` - `deliveryMethod` - `documentVisibility` - `email` (If you provide an email address in this method, it will be treated as a new email address, even if it is exactly the same as the current address. Do not provide an email address if you do not want a correction email sent.) - `emailNotification` - `idCheckConfigurationName` - `identityVerification` - `name` - `note` - `phoneAuthentication` - `recipientType` (For this to work, you must also change the recipient object to match the recipient type.) - `requireIdLookup` - `routingOrder` - `signingGroupId` (You can change this ID to switch to a different signing group and its corresponding set of recipients.) - `smsAuthentication` - `suppressEmails` - `userName`  If the recipient has signed, but the envelope is still active, the method will return success, but the `recipientUpdateResults` property in the response will include an error that the recipient could not be updated:  ``` {   \"recipientUpdateResults\": [     {       \"recipientId\": \"999\",       \"errorDetails\": {         \"errorCode\": \"RECIPIENT_UPDATE_FAILED\",         \"message\": \"The recipient could not be updated.  Recipient not in state that allows correction.\"       }     }   ] } ```  If the envelope is completed, and you try to change a recipient's address, the method will fail with this error:  ``` {   \"errorCode\": \"ENVELOPE_INVALID_STATUS\",   \"message\": \"Invalid envelope status. Envelope status is not one of: Created, Sent, Delivered, Correct.\" } ```  **Note:** This method works on recipients only. To add recipient tabs, use methods from the [EnvelopeRecipientTabs][recipientTabs] resource. For example, this request body will add a recipient (`astanton@example.com`) but **NOT** the Sign Here recipient tab.  ```json {   \"signers\": [     {       \"email\": \"astanton@example.com\",       \"name\": \"Anne Stanton\",       \"recipientId\": \"1\", // THIS WILL NOT WORK       \"tabs\": {         \"signHereTabs\": [           {             \"anchorString\": \"below\",             \"tooltip\": \"please sign here3\"           },           . . .         ]       }     }   ] } ```   [EnvelopeRecipients-create]: /docs/esign-rest-api/reference/envelopes/enveloperecipients/create/ [recipientTabs]: /docs/esign-rest-api/reference/envelopes/enveloperecipienttabs/  

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:combine_same_order_recipients` (String.t): When **true,** recipients are combined or merged with matching recipients. Recipient matching occurs as part of [template matching](https://support.docusign.com/s/document-item?bundleId=jux1643235969954&topicId=fxo1578456612662.html), and is based on Recipient Role and Routing Order.
    - `:offline_signing` (String.t): Indicates if offline signing is enabled for the recipient when a network connection is unavailable. 
    - `:resend_envelope` (String.t): When **true,** forces the envelope to be resent if it would not be resent otherwise.  Ordinarily, if the recipient's routing order is before or the same as the envelope's next recipient, the envelope is not resent.  Setting this query parameter to **false** has no effect and is the same as omitting it altogether. 
    - `:body` (EnvelopeRecipients): 

  ### Returns

  - `{:ok, DocuSign.Model.RecipientsUpdateSummary.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_put_recipients(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.RecipientsUpdateSummary.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def recipients_put_recipients(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :combine_same_order_recipients => :query,
      :offline_signing => :query,
      :resend_envelope => :query,
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/recipients")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.RecipientsUpdateSummary},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Creates an envelope recipient preview.
  Returns a URL to preview the recipients' view of a draft envelope or template. You can embed this view in your application to enable the sender to preview the recipients' experience.  You must specify a `returnUrl` value in the request body.  For more information, see [Preview and Send](https://support.docusign.com/s/document-item?bundleId=ulp1643236876813&topicId=oeg1578456408976.html).

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:body` (RecipientPreviewRequest): 

  ### Returns

  - `{:ok, DocuSign.Model.ViewUrl.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec views_post_envelope_recipient_preview(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ViewUrl.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def views_post_envelope_recipient_preview(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/views/recipient_preview")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, DocuSign.Model.ViewUrl},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Create the link to the page for manually reviewing IDs.
  This method returns the URL of the page that allows a sender to [manually review](https://support.docusign.com/s/document-item?bundleId=ced1643229641057&topicId=lyp1578456530647.html) the ID of a recipient. 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): A value that identifies your account. This value is automatically generated by Docusign for any account you create. Copy the value from the API Account ID field in the [AppsI and Keys](https://support.docusign.com/s/document-item?bundleId=pik1583277475390&topicId=pmp1583277397015.html) page.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `recipient_id` (String.t): A GUID value that Docusign assigns to identify each recipient in an envelope. This value is globally unique for all recipients, not just those in your account.  The specified recipient must belong to a workflow that allows the [manual review](https://support.docusign.com/s/document-item?bundleId=pik1583277475390&topicId=eya1583277454804.html) of IDs. In addition, the status of the automatic verification for this recipient must return `Failed` and the value of the `vendorFailureStatusCode` field must be `MANUAL_REVIEW_STARTED` as shown in the following extract of a response to the [GET ENVELOPE](/docs/esign-rest-api/reference/envelopes/envelopes/get/) method: <p>  ``` \"recipientAuthenticationStatus\": {        \"identityVerificationResult\": {               \"status\": \"Failed\",              \"eventTimestamp\": \"2020-09-04T16:59:42.8045667Z\",              \"vendorFailureStatusCode\": \"MANUAL_REVIEW_STARTED\"         }   } ```
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.ViewUrl.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec views_post_recipient_manual_review_view(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ViewUrl.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def views_post_recipient_manual_review_view(
        connection,
        account_id,
        envelope_id,
        recipient_id,
        _opts \\ []
      ) do
    request =
      %{}
      |> method(:post)
      |> url(
        "/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/recipients/#{recipient_id}/views/identity_manual_review"
      )
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, DocuSign.Model.ViewUrl},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end
end
