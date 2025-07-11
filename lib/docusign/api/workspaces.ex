# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.Workspaces do
  @moduledoc """
  API calls for all endpoints tagged `Workspaces`.
  """

  import DocuSign.RequestBuilder

  alias DocuSign.Connection
  alias DocuSign.Model.ErrorDetails
  alias DocuSign.Model.Workspace
  alias DocuSign.Model.WorkspaceList

  @doc """
  Delete Workspace
  Deletes an existing workspace (logically).

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `workspace_id` (String.t): The ID of the workspace.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.Workspace.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec workspace_delete_workspace(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, Workspace.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def workspace_delete_workspace(connection, account_id, workspace_id, _opts \\ []) do
    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/workspaces/#{workspace_id}")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, Workspace},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Get Workspace
  Retrieves properties about a workspace given a unique workspaceId.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `workspace_id` (String.t): The ID of the workspace.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.Workspace.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec workspace_get_workspace(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, Workspace.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def workspace_get_workspace(connection, account_id, workspace_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/workspaces/#{workspace_id}")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, Workspace},
      {400, ErrorDetails}
    ])
  end

  @doc """
  List Workspaces
  Gets information about the Workspaces that have been created.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.WorkspaceList.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec workspace_get_workspaces(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, WorkspaceList.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def workspace_get_workspaces(connection, account_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/workspaces")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, WorkspaceList},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Create a Workspace
  This method creates a new workspace.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (Workspace):

  ### Returns

  - `{:ok, DocuSign.Model.Workspace.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec workspace_post_workspace(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, Workspace.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def workspace_post_workspace(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/workspaces")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, Workspace},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Update Workspace
  Updates information about a specific workspace.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `workspace_id` (String.t): The ID of the workspace.
  - `opts` (keyword): Optional parameters
    - `:body` (Workspace):

  ### Returns

  - `{:ok, DocuSign.Model.Workspace.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec workspace_put_workspace(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, Workspace.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def workspace_put_workspace(connection, account_id, workspace_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/workspaces/#{workspace_id}")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, Workspace},
      {400, ErrorDetails}
    ])
  end
end
