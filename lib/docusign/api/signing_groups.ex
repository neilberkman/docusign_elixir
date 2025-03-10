# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.SigningGroups do
  @moduledoc """
  API calls for all endpoints tagged `SigningGroups`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes one or more signing groups.
  Deletes one or more signing groups in the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (SigningGroupInformation): 

  ### Returns

  - `{:ok, DocuSign.Model.SigningGroupInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec signing_groups_delete_signing_groups(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.SigningGroupInformation.t()}
          | {:error, Tesla.Env.t()}
  def signing_groups_delete_signing_groups(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/signing_groups")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.SigningGroupInformation},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Gets information about a signing group. 
  Retrieves information, including group member information, for the specified signing group. 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `signing_group_id` (String.t): The ID of the [signing group](https://support.docusign.com/s/document-item?bundleId=gav1643676262430&topicId=zgn1578456447934.html). 
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.SigningGroup.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec signing_groups_get_signing_group(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.SigningGroup.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def signing_groups_get_signing_group(connection, account_id, signing_group_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/signing_groups/#{signing_group_id}")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.SigningGroup},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Gets a list of the Signing Groups in an account.
  Retrieves a list of all signing groups in the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:group_type` (String.t): Filters by the type of signing group. Valid values: * `sharedSigningGroup` * `privateSigningGroup` * `systemSigningGroup`
    - `:include_users` (String.t): When **true,** the response includes the signing group members. 

  ### Returns

  - `{:ok, DocuSign.Model.SigningGroupInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec signing_groups_get_signing_groups(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.SigningGroupInformation.t()}
          | {:error, Tesla.Env.t()}
  def signing_groups_get_signing_groups(connection, account_id, opts \\ []) do
    optional_params = %{
      :group_type => :query,
      :include_users => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/signing_groups")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.SigningGroupInformation},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Creates a signing group. 
  Creates one or more signing groups.   Multiple signing groups can be created in one call. Only users with account administrator privileges can create signing groups.   An account can have a maximum of 50 signing groups. Each signing group can have a maximum of 50 group members.   Signing groups can be used by any account user.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (SigningGroupInformation): 

  ### Returns

  - `{:ok, DocuSign.Model.SigningGroupInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec signing_groups_post_signing_groups(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.SigningGroupInformation.t()}
          | {:error, Tesla.Env.t()}
  def signing_groups_post_signing_groups(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/signing_groups")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, DocuSign.Model.SigningGroupInformation},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Updates a signing group. 
  Updates signing group name and member information. You can also add new members to the signing group. A signing group can have a maximum of 50 members. 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `signing_group_id` (String.t): The ID of the [signing group](https://support.docusign.com/s/document-item?bundleId=gav1643676262430&topicId=zgn1578456447934.html). 
  - `opts` (keyword): Optional parameters
    - `:body` (SigningGroup): 

  ### Returns

  - `{:ok, DocuSign.Model.SigningGroup.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec signing_groups_put_signing_group(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.SigningGroup.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def signing_groups_put_signing_group(connection, account_id, signing_group_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/signing_groups/#{signing_group_id}")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.SigningGroup},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Updates signing group names.
  Updates the name of one or more existing signing groups. 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (SigningGroupInformation): 

  ### Returns

  - `{:ok, DocuSign.Model.SigningGroupInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec signing_groups_put_signing_groups(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.SigningGroupInformation.t()}
          | {:error, Tesla.Env.t()}
  def signing_groups_put_signing_groups(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/signing_groups")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.SigningGroupInformation},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end
end
