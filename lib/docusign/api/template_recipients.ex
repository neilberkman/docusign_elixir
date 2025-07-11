# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.TemplateRecipients do
  @moduledoc """
  API calls for all endpoints tagged `TemplateRecipients`.
  """

  import DocuSign.RequestBuilder

  alias DocuSign.Connection
  alias DocuSign.Model.ErrorDetails
  alias DocuSign.Model.Recipients
  alias DocuSign.Model.RecipientsUpdateSummary
  alias DocuSign.Model.ViewUrl

  @doc """
  Deletes the specified recipient file from a template.
  Deletes the specified recipient file from the specified template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `recipient_id` (String.t): A local reference used to map recipients to other objects, such as specific document tabs.  A `recipientId` must be either an integer or a GUID, and the `recipientId` must be unique within an envelope.  For example, many envelopes assign the first recipient a `recipientId` of `1`.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (TemplateRecipients):

  ### Returns

  - `{:ok, DocuSign.Model.Recipients.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_delete_template_recipient(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, ErrorDetails.t()}
          | {:ok, Recipients.t()}
          | {:error, Tesla.Env.t()}
  def recipients_delete_template_recipient(connection, account_id, recipient_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/recipients/#{recipient_id}")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, Recipients},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Deletes recipients from a template.
  Deletes one or more recipients from a template. Recipients to be deleted are listed in the request, with the `recipientId` being used as the key for deleting recipients.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (TemplateRecipients):

  ### Returns

  - `{:ok, DocuSign.Model.Recipients.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_delete_template_recipients(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, ErrorDetails.t()}
          | {:ok, Recipients.t()}
          | {:error, Tesla.Env.t()}
  def recipients_delete_template_recipients(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/recipients")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, Recipients},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets recipient information from a template.
  Retrieves the information for all recipients in the specified template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:include_anchor_tab_locations` (String.t):  When **true** and `include_tabs` is set to **true,** all tabs with anchor tab properties are included in the response.
    - `:include_extended` (String.t):  When **true,** the extended properties are included in the response.
    - `:include_tabs` (String.t): When **true,** the tab information associated with the recipient is included in the response.

  ### Returns

  - `{:ok, DocuSign.Model.Recipients.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_get_template_recipients(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, Recipients.t()}
          | {:error, Tesla.Env.t()}
  def recipients_get_template_recipients(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :include_anchor_tab_locations => :query,
      :include_extended => :query,
      :include_tabs => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/recipients")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, Recipients},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Adds tabs for a recipient.
  Adds one or more recipients to a template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:resend_envelope` (String.t): When **true,** resends the envelope to the recipients that you specify in the request body. Use this parameter to resend the envelope to a recipient who deleted the original email notification.  **Note:** Correcting an envelope is a different process. Docusign always resends an envelope when you correct it, regardless of the value that you enter here.
    - `:body` (TemplateRecipients):

  ### Returns

  - `{:ok, DocuSign.Model.Recipients.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_post_template_recipients(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, Recipients.t()}
          | {:error, Tesla.Env.t()}
  def recipients_post_template_recipients(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body,
      :resend_envelope => :query
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/recipients")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, Recipients},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Updates recipients in a template.
  Updates recipients in a template.   You can edit the following properties: `email`, `userName`, `routingOrder`, `faxNumber`, `deliveryMethod`, `accessCode`, and `requireIdLookup`.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:resend_envelope` (String.t): When **true,** resends the envelope to the recipients that you specify in the request body. Use this parameter to resend the envelope to a recipient who deleted the original email notification.  **Note:** Correcting an envelope is a different process. Docusign always resends an envelope when you correct it, regardless of the value that you enter here.
    - `:body` (TemplateRecipients):

  ### Returns

  - `{:ok, DocuSign.Model.RecipientsUpdateSummary.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_put_template_recipients(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, RecipientsUpdateSummary.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def recipients_put_template_recipients(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body,
      :resend_envelope => :query
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/recipients")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, RecipientsUpdateSummary},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Creates a template recipient preview.
  This method returns a URL for a template recipient preview  in the Docusign UI that you can embed in your application. You use this method to enable the sender to preview the recipients' experience.  For more information, see [Preview and Send](https://support.docusign.com/s/document-item?bundleId=ulp1643236876813&topicId=oeg1578456408976.html).

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (RecipientPreviewRequest):

  ### Returns

  - `{:ok, DocuSign.Model.ViewUrl.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec views_post_template_recipient_preview(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, ViewUrl.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def views_post_template_recipient_preview(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/views/recipient_preview")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, ViewUrl},
      {400, ErrorDetails}
    ])
  end
end
