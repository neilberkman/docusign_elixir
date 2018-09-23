# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Api.UserSocialAccountLogins do
  @moduledoc """
  API calls for all endpoints tagged `UserSocialAccountLogins`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes user&#39;s social account.
  Deletes a social account from a use&#39;s account.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - user_id (String.t): The user ID of the user being accessed. Generally this is the user ID of the authenticated user, but if the authenticated user is an Admin on the account, this may be another user the Admin user is accessing.
  - opts (KeywordList): [optional] Optional parameters
    - :user_social_account_logins (UserSocialAccountLogins): 

  ## Returns

  {:ok, %{}} on success
  {:error, info} on failure
  """
  @spec user_social_login_delete_user_social_login(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, nil} | {:error, Tesla.Env.t()}
  def user_social_login_delete_user_social_login(connection, account_id, user_id, opts \\ []) do
    optional_params = %{
      :UserSocialAccountLogins => :body
    }

    %{}
    |> method(:delete)
    |> url("/v2/accounts/#{account_id}/users/#{user_id}/social")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(false)
  end

  @doc """
  Gets a list of a user&#39;s social accounts.
  Retrieves a list of social accounts linked to a user&#39;s account.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - user_id (String.t): The user ID of the user being accessed. Generally this is the user ID of the authenticated user, but if the authenticated user is an Admin on the account, this may be another user the Admin user is accessing.
  - opts (KeywordList): [optional] Optional parameters

  ## Returns

  {:ok, %DocuSign.Model.UserSocialIdResult{}} on success
  {:error, info} on failure
  """
  @spec user_social_login_get_user_social_login(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, DocuSign.Model.UserSocialIdResult.t()} | {:error, Tesla.Env.t()}
  def user_social_login_get_user_social_login(connection, account_id, user_id, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/v2/accounts/#{account_id}/users/#{user_id}/social")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.UserSocialIdResult{})
  end

  @doc """
  Adds social account for a user.
  Adds a new social account to a user&#39;s account.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - user_id (String.t): The user ID of the user being accessed. Generally this is the user ID of the authenticated user, but if the authenticated user is an Admin on the account, this may be another user the Admin user is accessing.
  - opts (KeywordList): [optional] Optional parameters
    - :user_social_account_logins (UserSocialAccountLogins): 

  ## Returns

  {:ok, %{}} on success
  {:error, info} on failure
  """
  @spec user_social_login_put_user_social_login(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, nil} | {:error, Tesla.Env.t()}
  def user_social_login_put_user_social_login(connection, account_id, user_id, opts \\ []) do
    optional_params = %{
      :UserSocialAccountLogins => :body
    }

    %{}
    |> method(:put)
    |> url("/v2/accounts/#{account_id}/users/#{user_id}/social")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(false)
  end
end