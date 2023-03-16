# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.TemplateCustomFields do
  @moduledoc """
  API calls for all endpoints tagged `TemplateCustomFields`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes envelope custom fields in a template.
  Deletes envelope custom fields in a template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (TemplateCustomFields):

  ### Returns

  - `{:ok, DocuSign.Model.CustomFields.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec custom_fields_delete_template_custom_fields(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.CustomFields.t()}
          | {:error, Tesla.Env.t()}
  def custom_fields_delete_template_custom_fields(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/custom_fields")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.CustomFields{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets the custom document fields from a template.
  Retrieves the custom document field information from an existing template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.CustomFields.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec custom_fields_get_template_custom_fields(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.CustomFields.t()}
          | {:error, Tesla.Env.t()}
  def custom_fields_get_template_custom_fields(connection, account_id, template_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/custom_fields")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.CustomFields{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Creates custom document fields in an existing template document.
  Creates custom document fields in an existing template document.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (TemplateCustomFields):

  ### Returns

  - `{:ok, DocuSign.Model.CustomFields.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec custom_fields_post_template_custom_fields(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.CustomFields.t()}
          | {:error, Tesla.Env.t()}
  def custom_fields_post_template_custom_fields(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/custom_fields")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, %DocuSign.Model.CustomFields{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates envelope custom fields in a template.
  Updates the custom fields in a template.  Each custom field used in a template must have a unique name.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (TemplateCustomFields):

  ### Returns

  - `{:ok, DocuSign.Model.CustomFields.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec custom_fields_put_template_custom_fields(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.CustomFields.t()}
          | {:error, Tesla.Env.t()}
  def custom_fields_put_template_custom_fields(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/custom_fields")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.CustomFields{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end
