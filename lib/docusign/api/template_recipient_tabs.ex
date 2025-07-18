# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.TemplateRecipientTabs do
  @moduledoc """
  API calls for all endpoints tagged `TemplateRecipientTabs`.
  """

  import DocuSign.RequestBuilder

  alias DocuSign.Connection
  alias DocuSign.Model.ErrorDetails
  alias DocuSign.Model.Tabs

  @doc """
  Deletes the tabs associated with a recipient in a template.
  Deletes one or more tabs associated with a recipient in a template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `recipient_id` (String.t): A local reference used to map recipients to other objects, such as specific document tabs.  A `recipientId` must be either an integer or a GUID, and the `recipientId` must be unique within an envelope.  For example, many envelopes assign the first recipient a `recipientId` of `1`.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (TemplateTabs):

  ### Returns

  - `{:ok, DocuSign.Model.Tabs.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_delete_template_recipient_tabs(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, Tabs.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def recipients_delete_template_recipient_tabs(connection, account_id, recipient_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/recipients/#{recipient_id}/tabs")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, Tabs},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets the tabs information for a signer or sign-in-person recipient in a template.
  Gets the tabs information for a signer or sign-in-person recipient in a template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `recipient_id` (String.t): A local reference used to map recipients to other objects, such as specific document tabs.  A `recipientId` must be either an integer or a GUID, and the `recipientId` must be unique within an envelope.  For example, many envelopes assign the first recipient a `recipientId` of `1`.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:include_anchor_tab_locations` (String.t): When **true,** all tabs with anchor tab properties are included in the response. The default value is **false.**
    - `:include_metadata` (String.t): When **true,** the response includes metadata indicating which properties are editable.

  ### Returns

  - `{:ok, DocuSign.Model.Tabs.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_get_template_recipient_tabs(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, Tabs.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def recipients_get_template_recipient_tabs(connection, account_id, recipient_id, template_id, opts \\ []) do
    optional_params = %{
      :include_anchor_tab_locations => :query,
      :include_metadata => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/recipients/#{recipient_id}/tabs")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, Tabs},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Adds tabs for a recipient.
  Adds one or more tabs for a recipient.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `recipient_id` (String.t): A local reference used to map recipients to other objects, such as specific document tabs.  A `recipientId` must be either an integer or a GUID, and the `recipientId` must be unique within an envelope.  For example, many envelopes assign the first recipient a `recipientId` of `1`.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (TemplateTabs):

  ### Returns

  - `{:ok, DocuSign.Model.Tabs.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_post_template_recipient_tabs(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, Tabs.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def recipients_post_template_recipient_tabs(connection, account_id, recipient_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/recipients/#{recipient_id}/tabs")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, Tabs},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Updates the tabs for a recipient.
  Updates one or more tabs for a recipient in a template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `recipient_id` (String.t): A local reference used to map recipients to other objects, such as specific document tabs.  A `recipientId` must be either an integer or a GUID, and the `recipientId` must be unique within an envelope.  For example, many envelopes assign the first recipient a `recipientId` of `1`.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (TemplateTabs):

  ### Returns

  - `{:ok, DocuSign.Model.Tabs.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipients_put_template_recipient_tabs(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, Tabs.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def recipients_put_template_recipient_tabs(connection, account_id, recipient_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/recipients/#{recipient_id}/tabs")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, Tabs},
      {400, ErrorDetails}
    ])
  end
end
