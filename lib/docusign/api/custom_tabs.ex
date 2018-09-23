# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Api.CustomTabs do
  @moduledoc """
  API calls for all endpoints tagged `CustomTabs`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes custom tab information.
  Deletes the custom from the specified account.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - custom_tab_id (String.t): 
  - opts (KeywordList): [optional] Optional parameters

  ## Returns

  {:ok, %{}} on success
  {:error, info} on failure
  """
  @spec tab_delete_custom_tab(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, nil} | {:error, Tesla.Env.t()}
  def tab_delete_custom_tab(connection, account_id, custom_tab_id, _opts \\ []) do
    %{}
    |> method(:delete)
    |> url("/v2/accounts/#{account_id}/tab_definitions/#{custom_tab_id}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(false)
  end

  @doc """
  Gets custom tab information.
  Retrieves information about the requested custom tab on the specified account.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - custom_tab_id (String.t): 
  - opts (KeywordList): [optional] Optional parameters

  ## Returns

  {:ok, %DocuSign.Model.CustomTabs{}} on success
  {:error, info} on failure
  """
  @spec tab_get_custom_tab(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.CustomTabs.t()} | {:error, Tesla.Env.t()}
  def tab_get_custom_tab(connection, account_id, custom_tab_id, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/v2/accounts/#{account_id}/tab_definitions/#{custom_tab_id}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.CustomTabs{})
  end

  @doc """
  Updates custom tab information.  
  Updates the information in a custom tab for the specified account.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - custom_tab_id (String.t): 
  - opts (KeywordList): [optional] Optional parameters
    - :custom_tabs (CustomTabs): 

  ## Returns

  {:ok, %DocuSign.Model.CustomTabs{}} on success
  {:error, info} on failure
  """
  @spec tab_put_custom_tab(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.CustomTabs.t()} | {:error, Tesla.Env.t()}
  def tab_put_custom_tab(connection, account_id, custom_tab_id, opts \\ []) do
    optional_params = %{
      :CustomTabs => :body
    }

    %{}
    |> method(:put)
    |> url("/v2/accounts/#{account_id}/tab_definitions/#{custom_tab_id}")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.CustomTabs{})
  end

  @doc """
  Gets a list of all account tabs.
  Retrieves a list of all tabs associated with the account.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - opts (KeywordList): [optional] Optional parameters
    - :custom_tab_only (String.t): When set to **true**, only custom tabs are returned in the response. 

  ## Returns

  {:ok, %DocuSign.Model.TabMetadataList{}} on success
  {:error, info} on failure
  """
  @spec tabs_get_tab_definitions(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.TabMetadataList.t()} | {:error, Tesla.Env.t()}
  def tabs_get_tab_definitions(connection, account_id, opts \\ []) do
    optional_params = %{
      :custom_tab_only => :query
    }

    %{}
    |> method(:get)
    |> url("/v2/accounts/#{account_id}/tab_definitions")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.TabMetadataList{})
  end

  @doc """
  Creates a custom tab.
  Creates a tab with pre-defined properties, such as a text tab with a certain font type and validation pattern. Users can access the custom tabs when sending documents through the DocuSign web application.  Custom tabs can be created for approve, checkbox, company, date, date signed, decline, email, email address, envelope ID, first name, formula, full name, initial here, last name, list, note, number, radio, sign here, signer attachment, SSN, text, title, and zip tabs.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - opts (KeywordList): [optional] Optional parameters
    - :custom_tabs (CustomTabs): 

  ## Returns

  {:ok, %DocuSign.Model.CustomTabs{}} on success
  {:error, info} on failure
  """
  @spec tabs_post_tab_definitions(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.CustomTabs.t()} | {:error, Tesla.Env.t()}
  def tabs_post_tab_definitions(connection, account_id, opts \\ []) do
    optional_params = %{
      :CustomTabs => :body
    }

    %{}
    |> method(:post)
    |> url("/v2/accounts/#{account_id}/tab_definitions")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.CustomTabs{})
  end
end