# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.CustomTabs do
  @moduledoc """
  API calls for all endpoints tagged `CustomTabs`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes custom tab information.
  Deletes the custom from the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `custom_tab_id` (String.t): The DocuSign-generated custom tab ID for the custom tab to be applied. This can only be used when adding new tabs for a recipient. When used, the new tab inherits all the custom tab properties.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec tab_delete_custom_tab(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def tab_delete_custom_tab(connection, account_id, custom_tab_id, _opts \\ []) do
    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/tab_definitions/#{custom_tab_id}")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets custom tab information.
  Retrieves information about the requested custom tab on the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `custom_tab_id` (String.t): The DocuSign-generated custom tab ID for the custom tab to be applied. This can only be used when adding new tabs for a recipient. When used, the new tab inherits all the custom tab properties.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.TabMetadata.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec tab_get_custom_tab(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.TabMetadata.t()}
          | {:error, Tesla.Env.t()}
  def tab_get_custom_tab(connection, account_id, custom_tab_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/tab_definitions/#{custom_tab_id}")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.TabMetadata{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates custom tab information.
  Updates the information in a custom tab for the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `custom_tab_id` (String.t): The DocuSign-generated custom tab ID for the custom tab to be applied. This can only be used when adding new tabs for a recipient. When used, the new tab inherits all the custom tab properties.
  - `opts` (keyword): Optional parameters
    - `:body` (TabMetadata):

  ### Returns

  - `{:ok, DocuSign.Model.TabMetadata.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec tab_put_custom_tab(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.TabMetadata.t()}
          | {:error, Tesla.Env.t()}
  def tab_put_custom_tab(connection, account_id, custom_tab_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/tab_definitions/#{custom_tab_id}")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.TabMetadata{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets a list of all account tabs.
  Retrieves a list of all tabs associated with the account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:custom_tab_only` (String.t): When **true,** only custom tabs are returned in the response.

  ### Returns

  - `{:ok, DocuSign.Model.TabMetadataList.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec tabs_get_tab_definitions(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.TabMetadataList.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def tabs_get_tab_definitions(connection, account_id, opts \\ []) do
    optional_params = %{
      :custom_tab_only => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/tab_definitions")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.TabMetadataList{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Creates a custom tab.
  Creates a tab with pre-defined properties, such as a text tab with a certain font type and validation pattern. Users can access the custom tabs when sending documents through the DocuSign web application.  Custom tabs can be created for approve, checkbox, company, date, date signed, decline, email, email address, envelope ID, first name, formula, full name, initial here, last name, list, note, number, radio, sign here, signer attachment, SSN, text, title, and zip tabs.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (TabMetadata):

  ### Returns

  - `{:ok, DocuSign.Model.TabMetadata.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec tabs_post_tab_definitions(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.TabMetadata.t()}
          | {:error, Tesla.Env.t()}
  def tabs_post_tab_definitions(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/tab_definitions")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, %DocuSign.Model.TabMetadata{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end
