# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Api.SigningGroups do
  @moduledoc """
  API calls for all endpoints tagged `SigningGroups`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes one or more signing groups.
  Deletes one or more signing groups in the specified account.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - opts (KeywordList): [optional] Optional parameters
    - :signing_group_information (SigningGroupInformation): 

  ## Returns

  {:ok, %DocuSign.Model.SigningGroupInformation{}} on success
  {:error, info} on failure
  """
  @spec signing_groups_delete_signing_groups(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.SigningGroupInformation.t()} | {:error, Tesla.Env.t()}
  def signing_groups_delete_signing_groups(connection, account_id, opts \\ []) do
    optional_params = %{
      :signingGroupInformation => :body
    }

    %{}
    |> method(:delete)
    |> url("/v2/accounts/#{account_id}/signing_groups")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.SigningGroupInformation{})
  end

  @doc """
  Gets information about a signing group. 
  Retrieves information, including group member information, for the specified signing group. 

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - signing_group_id (String.t): 
  - opts (KeywordList): [optional] Optional parameters

  ## Returns

  {:ok, %DocuSign.Model.SigningGroups{}} on success
  {:error, info} on failure
  """
  @spec signing_groups_get_signing_group(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.SigningGroups.t()} | {:error, Tesla.Env.t()}
  def signing_groups_get_signing_group(connection, account_id, signing_group_id, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/v2/accounts/#{account_id}/signing_groups/#{signing_group_id}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.SigningGroups{})
  end

  @doc """
  Gets a list of the Signing Groups in an account.
  Retrieves a list of all signing groups in the specified account.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - opts (KeywordList): [optional] Optional parameters
    - :group_type (String.t): 
    - :include_users (String.t): When set to **true**, the response includes the signing group members. 

  ## Returns

  {:ok, %DocuSign.Model.SigningGroupInformation{}} on success
  {:error, info} on failure
  """
  @spec signing_groups_get_signing_groups(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.SigningGroupInformation.t()} | {:error, Tesla.Env.t()}
  def signing_groups_get_signing_groups(connection, account_id, opts \\ []) do
    optional_params = %{
      :group_type => :query,
      :include_users => :query
    }

    %{}
    |> method(:get)
    |> url("/v2/accounts/#{account_id}/signing_groups")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.SigningGroupInformation{})
  end

  @doc """
  Creates a signing group. 
  Creates one or more signing groups.   Multiple signing groups can be created in one call. Only users with account administrator privileges can create signing groups.   An account can have a maximum of 50 signing groups. Each signing group can have a maximum of 50 group members.   Signing groups can be used by any account user.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - opts (KeywordList): [optional] Optional parameters
    - :signing_group_information (SigningGroupInformation): 

  ## Returns

  {:ok, %DocuSign.Model.SigningGroupInformation{}} on success
  {:error, info} on failure
  """
  @spec signing_groups_post_signing_groups(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.SigningGroupInformation.t()} | {:error, Tesla.Env.t()}
  def signing_groups_post_signing_groups(connection, account_id, opts \\ []) do
    optional_params = %{
      :signingGroupInformation => :body
    }

    %{}
    |> method(:post)
    |> url("/v2/accounts/#{account_id}/signing_groups")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.SigningGroupInformation{})
  end

  @doc """
  Updates a signing group. 
  Updates signing group name and member information. You can also add new members to the signing group. A signing group can have a maximum of 50 members. 

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - signing_group_id (String.t): 
  - opts (KeywordList): [optional] Optional parameters
    - :signing_groups (SigningGroups): 

  ## Returns

  {:ok, %DocuSign.Model.SigningGroups{}} on success
  {:error, info} on failure
  """
  @spec signing_groups_put_signing_group(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.SigningGroups.t()} | {:error, Tesla.Env.t()}
  def signing_groups_put_signing_group(connection, account_id, signing_group_id, opts \\ []) do
    optional_params = %{
      :SigningGroups => :body
    }

    %{}
    |> method(:put)
    |> url("/v2/accounts/#{account_id}/signing_groups/#{signing_group_id}")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.SigningGroups{})
  end

  @doc """
  Updates signing group names.
  Updates the name of one or more existing signing groups. 

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - opts (KeywordList): [optional] Optional parameters
    - :signing_group_information (SigningGroupInformation): 

  ## Returns

  {:ok, %DocuSign.Model.SigningGroupInformation{}} on success
  {:error, info} on failure
  """
  @spec signing_groups_put_signing_groups(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.SigningGroupInformation.t()} | {:error, Tesla.Env.t()}
  def signing_groups_put_signing_groups(connection, account_id, opts \\ []) do
    optional_params = %{
      :signingGroupInformation => :body
    }

    %{}
    |> method(:put)
    |> url("/v2/accounts/#{account_id}/signing_groups")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.SigningGroupInformation{})
  end
end