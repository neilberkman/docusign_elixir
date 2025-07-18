# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.TemplateLocks do
  @moduledoc """
  API calls for all endpoints tagged `TemplateLocks`.
  """

  import DocuSign.RequestBuilder

  alias DocuSign.Connection
  alias DocuSign.Model.ErrorDetails
  alias DocuSign.Model.LockInformation

  @doc """
  Deletes a template lock.
  Deletes the lock from the specified template. The user deleting the lock must be the same user who locked the template.  You must include the `X-DocuSign-Edit` header as described in [TemplateLocks: create](/docs/esign-rest-api/reference/templates/templatelocks/create/).  This method takes an optional query parameter that lets you specify whether changes made while the template was locked are kept or discarded.   | Query Parameter | Description                                                                                                                                                                         | | :-------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | | `save_changes`  | When **true** (the default), any changes made while the lock was active are saved. When **false,** any changes made while the template was locked are discarded. |   ### Related topics  - [Common API Tasks: Locking and unlocking envelopes](https://www.docusign.com/blog/dsdev-common-api-tasks-locking-and-unlocking-envelopes)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (LockRequest):

  ### Returns

  - `{:ok, DocuSign.Model.LockInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec lock_delete_template_lock(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, LockInformation.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def lock_delete_template_lock(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/lock")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, LockInformation},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets template lock information.
  Retrieves general information about a template lock.  The user requesting the information must be the same user who locked the template.  You can use this method to recover the lock information, including the `lockToken`, for a locked template. The `X-DocuSign-Edit` header is included in the response.  See [TemplateLocks: create](/docs/esign-rest-api/reference/templates/templatelocks/create/) for a description of the `X-DocuSign-Edit` header.  ### Related topics  - [Common API Tasks: Locking and unlocking envelopes](https://www.docusign.com/blog/dsdev-common-api-tasks-locking-and-unlocking-envelopes)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.LockInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec lock_get_template_lock(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, LockInformation.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def lock_get_template_lock(connection, account_id, template_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/lock")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, LockInformation},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Locks a template.
  This method locks the specified template and sets the time until the lock expires to prevent other users or recipients from changing the template.  The response to this request includes a `lockToken` parameter that you must use in the `X-DocuSign-Edit` header for every PUT method (typically a method that updates a template) while the template is locked.   If you do not provide the `lockToken` when accessing a locked template, you will get the following error:  ``` {    \"errorCode\": \"EDIT_LOCK_NOT_LOCK_OWNER\",    \"message\": \"The user is not the owner of the lock. The template is locked by another user or in another application\" } ```   ### The X-DocuSign-Edit header  The `X-DocuSign-Edit` header looks like this and can be specified in either JSON or XML.  **JSON** ``` {   \"LockToken\": \"token-from-response\",   \"LockDurationInSeconds\": \"600\" } ```  **XML** ``` <DocuSignEdit>   <LockToken>token-from-response</LockToken>   <LockDurationInSeconds>600</LockDurationInSeconds> </DocuSignEdit> ```  In the actual HTTP header, you would remove the linebreaks:  ``` X-DocuSign-Edit: {\"LockToken\": \"token-from-response\", \"LockDurationInSeconds\": \"600\" }     or X-DocuSign-Edit:<DocuSignEdit><LockToken>token-from-response</LockToken><LockDurationInSeconds>600</LockDurationInSeconds></DocuSignEdit> ```   ### Related topics  - [Common API Tasks: Locking and unlocking envelopes](https://www.docusign.com/blog/dsdev-common-api-tasks-locking-and-unlocking-envelopes)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (LockRequest):

  ### Returns

  - `{:ok, DocuSign.Model.LockInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec lock_post_template_lock(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, LockInformation.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def lock_post_template_lock(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/lock")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, LockInformation},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Updates a template lock.
  Updates the lock information for a locked template.  You must include the `X-DocuSign-Edit` header as described in [TemplateLocks: create](/docs/esign-rest-api/reference/templates/templatelocks/create/).   Use this method to change the duration of the lock (`lockDurationInSeconds`) or the `lockedByApp` string.  The request body is a full `lockRequest` object, but you only need to specify the properties that you are updating. For example:  ``` {   \"lockDurationInSeconds\": \"3600\",   \"lockedByApp\": \"My Application\" } ```

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (LockRequest):

  ### Returns

  - `{:ok, DocuSign.Model.LockInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec lock_put_template_lock(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, LockInformation.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def lock_put_template_lock(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/lock")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, LockInformation},
      {400, ErrorDetails}
    ])
  end
end
