# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.Users do
  @moduledoc """
  API calls for all endpoints tagged `Users`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Gets the user information for a specified user.
  Retrieves the user information for the specified user.  For example:  ```json {   \"userName\": \"Tania Morales\",   \"userId\": \"6b67a1ee-xxxx-xxxx-xxxx-385763624163\",   \"userType\": \"CompanyUser\",   \"isAdmin\": \"False\",   \"isNAREnabled\": \"false\",   \"userStatus\": \"Active\",   \"uri\": \"/users/6b67a1ee-xxxx-xxxx-xxxx-385763624163\",   \"email\": \"examplename42@orobia.net\",   \"createdDateTime\": \"2019-04-01T22:11:56.4570000Z\",   \"userAddedToAccountDateTime\": \"0001-01-01T08:00:00.0000000Z\",   \"firstName\": \"Tania\",   \"lastName\": \"Morales\",   \"jobTitle\": \"\",   \"company\": \"Company\",   \"permissionProfileId\": \"12345678\",   \"permissionProfileName\": \"DocuSign Viewer\",   \"userSettings\": {. . .},   \"sendActivationOnInvalidLogin\": \"false\",   \"enableConnectForUser\": \"false\",   \"groupList\": [. . .],   \"workAddress\": {. . .},   \"homeAddress\": {. . .},   \"signatureImageUri\": \"/users/6b67a1ee-xxxx-xxxx-xxxx-385763624163/signatures/0304c47b-xxxx-xxxx-xxxx-c9673963bb50/signature_image\",   \"initialsImageUri\": \"/users/6b67a1ee-xxxx-xxxx-xxxx-385763624163/signatures/0304c47b-xxxx-xxxx-xxxx-c9673963bb50/initials_image\",   \"defaultAccountId\": \"f636f297-xxxx-xxxx-xxxx-8e7a14715950\" } ```

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `user_id` (String.t): The ID of the user to access.  **Note:** Users can only access their own information. A user, even one with Admin rights, cannot access another user's settings.
  - `opts` (keyword): Optional parameters
    - `:additional_info` (String.t): Setting this parameter has no effect in this operation.
    - `:email` (String.t): Setting this parameter has no effect in this operation.

  ### Returns

  - `{:ok, DocuSign.Model.UserInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec user_get_user(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.UserInformation.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def user_get_user(connection, account_id, user_id, opts \\ []) do
    optional_params = %{
      :additional_info => :query,
      :email => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/users/#{user_id}")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.UserInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Deletes the user profile image for the specified user.
  Deletes the user profile image from the  specified user's profile.  The userId parameter specified in the endpoint must match the authenticated user's user ID and the user must be a member of the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `user_id` (String.t): The ID of the user to access.  **Note:** Users can only access their own information. A user, even one with Admin rights, cannot access another user's settings.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec user_profile_image_delete_user_profile_image(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def user_profile_image_delete_user_profile_image(connection, account_id, user_id, _opts \\ []) do
    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/users/#{user_id}/profile/image")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Retrieves the user profile image for the specified user.
  Retrieves the user profile picture for the specified user.  The `userId` path parameter must match the authenticated user's user ID, and the user must be a member of the specified account.  | Return value      | Meaning                                                                        | | :---------------- | :----------------------------------------------------------------------------- | | `200 OK`          | The response contains the profile image in the same format as it was uploaded. | | `404 Not found`   | The user does not have a profile image.                                        | | `400 Bad request` | There was an error in the request. The response has more information.          |

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `user_id` (String.t): The ID of the user to access.  **Note:** Users can only access their own information. A user, even one with Admin rights, cannot access another user's settings.
  - `opts` (keyword): Optional parameters
    - `:encoding` (String.t): Reserved for DocuSign.

  ### Returns

  - `{:ok, String.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec user_profile_image_get_user_profile_image(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, DocuSign.Model.ErrorDetails.t()} | {:ok, String.t()} | {:error, Tesla.Env.t()}
  def user_profile_image_get_user_profile_image(connection, account_id, user_id, opts \\ []) do
    optional_params = %{
      :encoding => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/users/#{user_id}/profile/image")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates the user profile image for a specified user.
  Updates the user profile image by uploading an image to the user profile.  The supported image formats are: gif, png, jpeg, and bmp. The file must be less than 200K. For best viewing results, DocuSign recommends that the image is no more than 79 pixels wide and high.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `user_id` (String.t): The ID of the user to access.  **Note:** Users can only access their own information. A user, even one with Admin rights, cannot access another user's settings.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec user_profile_image_put_user_profile_image(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def user_profile_image_put_user_profile_image(connection, account_id, user_id, _opts \\ []) do
    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/users/#{user_id}/profile/image")
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates user information for the specified user.
  To update user information for a specific user, submit a [Users](#Users) object with updated field values in the request body of this operation.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `user_id` (String.t): The ID of the user to access.  **Note:** Users can only access their own information. A user, even one with Admin rights, cannot access another user's settings.
  - `opts` (keyword): Optional parameters
    - `:allow_all_languages` (String.t):
    - `:body` (UserInformation):

  ### Returns

  - `{:ok, DocuSign.Model.UserInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec user_put_user(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.UserInformation.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def user_put_user(connection, account_id, user_id, opts \\ []) do
    optional_params = %{
      :allow_all_languages => :query,
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/users/#{user_id}")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.UserInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets the user account settings for a specified user.
  Retrieves a list of the account settings and email notification information for the specified user.  The response returns the account setting name/value information and the email notification settings for the specified user. For more information, see [Users:create](/docs/esign-rest-api/reference/users/users/create/).

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `user_id` (String.t): The ID of the user to access.  **Note:** Users can only access their own information. A user, even one with Admin rights, cannot access another user's settings.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.UserSettingsInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec user_settings_get_user_settings(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.UserSettingsInformation.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def user_settings_get_user_settings(connection, account_id, user_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/users/#{user_id}/settings")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.UserSettingsInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates the user account settings for a specified user.
  Updates the account settings list and email notification types for the specified user.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `user_id` (String.t): The ID of the user to access.  **Note:** Users can only access their own information. A user, even one with Admin rights, cannot access another user's settings.
  - `opts` (keyword): Optional parameters
    - `:allow_all_languages` (String.t):
    - `:body` (UserSettingsInformation):

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec user_settings_put_user_settings(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def user_settings_put_user_settings(connection, account_id, user_id, opts \\ []) do
    optional_params = %{
      :allow_all_languages => :query,
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/users/#{user_id}/settings")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Closes one or more users in the account.
  Closes one or more users in the account, preventing them from accessing account features. Users are not permanently deleted.  The request body requires only the IDs of the users to close:  ```json {     \"users\": [         { \"userId\": \"6b67a1ee-xxxx-xxxx-xxxx-385763624163\" },         { \"userId\": \"b6c74c52-xxxx-xxxx-xxxx-457a81d88926\" },         { \"userId\": \"464f7988-xxxx-xxxx-xxxx-781ee556ab7a\" }     ] } ```  You can use [`Users:update`](/docs/esign-rest-api/reference/users/users/update/) to re-open a closed user.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:delete` (String.t): A list of groups to remove the user from. A comma-separated list of the following:  - `Groups` - `PermissionSet` - `SigningGroupsEmail`
    - `:body` (UserInfoList):

  ### Returns

  - `{:ok, DocuSign.Model.UsersResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec users_delete_users(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.UsersResponse.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def users_delete_users(connection, account_id, opts \\ []) do
    optional_params = %{
      :delete => :query,
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/users")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.UsersResponse{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Retrieves the list of users for the specified account.
  Retrieves the list of users for the specified account.  The response returns the list of users for the account, with information about the result set. If the `additional_info` query is added to the endpoint and set to **true,** full user information is returned for each user.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): (Required) The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:additional_info` (String.t): When **true,** the custom settings information is returned for each user in the account. If this parameter is omitted, the default behavior is **false.**
    - `:alternate_admins_only` (String.t):
    - `:count` (String.t): The maximum number of results to return.  Use `start_position` to specify the number of results to skip.  Valid values: `1` to `100`
    - `:domain_users_only` (String.t):
    - `:email` (String.t): Filters results based on the email address associated with the user that you want to return.  **Note:** You can use either this parameter or the `email_substring` parameter, but not both. For older accounts, this parameter might return multiple users who are associated with a single email address.
    - `:email_substring` (String.t): Filters results based on a fragment of an email address. For example, you could enter `gmail` to return all users who have Gmail addresses.  **Note:** You do not use a wildcard character with this parameter. You can use either this parameter or the `email` parameter, but not both.
    - `:group_id` (String.t): Filters results based on one or more group IDs.
    - `:include_usersettings_for_csv` (String.t): When **true,** the response includes the `userSettings` object data in CSV format.
    - `:login_status` (String.t): When **true,** the response includes the login status of each user.
    - `:not_group_id` (String.t): Return user records excluding the specified group IDs.
    - `:start_position` (String.t): The zero-based index of the result from which to start returning results.  Use with `count` to limit the number of results.  The default value is `0`.
    - `:status` (String.t): Filters results by user account status. A comma-separated list of any of the following:  * `ActivationRequired` * `ActivationSent` * `Active` * `Closed` * `Disabled`
    - `:user_name_substring` (String.t): Filters results based on a full or partial user name.  **Note:** When you enter a partial user name, you do not use a wildcard character.

  ### Returns

  - `{:ok, DocuSign.Model.UserInformationList.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec users_get_users(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.UserInformationList.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def users_get_users(connection, account_id, opts \\ []) do
    optional_params = %{
      :additional_info => :query,
      :alternate_admins_only => :query,
      :count => :query,
      :domain_users_only => :query,
      :email => :query,
      :email_substring => :query,
      :group_id => :query,
      :include_usersettings_for_csv => :query,
      :login_status => :query,
      :not_group_id => :query,
      :start_position => :query,
      :status => :query,
      :user_name_substring => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/users")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.UserInformationList{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Adds new users to the specified account.
  Adds new users to an account.   The body of this request is an array of `newUsers` objects. For each new user, you must provide at least the `userName` and `email` properties. The maximum number of users you can create in one request is 500 users.   The `userSettings` property specifies the actions users can perform. In the example below, Tal Mason will be able to send envelopes, and the activation email will be in French because the `locale` is set to `fr`.   ``` POST /restapi/v2.1/accounts/{accountId}/users Content-Type: application/json ``` ``` {   \"newUsers\": [     {       \"userName\": \"Claire Horace\",       \"email\": \"claire@example.com\"     },     {       \"userName\": \"Tal Mason\",       \"email\": \"talmason@example.com\",       \"company\": \"TeleSel\",       \"userSettings\": {         \"locale\": \"fr\",         \"canSendEnvelope\": true       }     }   ] } ```  A successful response is a `newUsers` array with information about the newly created users. If there was a problem in creating a user, that user entry will contain an `errorDetails` property that describes what went wrong.  ```json {   \"newUsers\": [     {       \"userId\": \"18f3be12-xxxx-xxxx-xxxx-883d8f9b8ade\",       \"uri\": \"/users/18f3be12-xxxx-xxxx-xxxx-883d8f9b8ade\",       \"email\": \"claire@example.com\",       \"userName\": \"Claire Horace\",       \"createdDateTime\": \"0001-01-01T08:00:00.0000000Z\",       \"errorDetails\": {         \"errorCode\": \"USER_ALREADY_EXISTS_IN_ACCOUNT\",         \"message\": \"Username and email combination already exists for this account.\"       }     },     {       \"userId\": \"be9899a3-xxxx-xxxx-xxxx-2c8dd7156e33\",       \"uri\": \"/users/be9899a3-xxxx-xxxx-xxxx-2c8dd7156e33\",       \"email\": \"talmason@example.com\",       \"userName\": \"Tal Mason\",       \"userStatus\": \"ActivationSent\",       \"createdDateTime\": \"2020-05-26T23:25:30.7330000Z\"     }   ] } ```

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (NewUsersDefinition):

  ### Returns

  - `{:ok, DocuSign.Model.NewUsersSummary.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec users_post_users(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.NewUsersSummary.t()}
          | {:error, Tesla.Env.t()}
  def users_post_users(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/users")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, %DocuSign.Model.NewUsersSummary{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Changes one or more users in the specified account.
  This method updates the information about one or more account users.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:allow_all_languages` (String.t):
    - `:body` (UserInformationList):

  ### Returns

  - `{:ok, DocuSign.Model.UserInformationList.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec users_put_users(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.UserInformationList.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def users_put_users(connection, account_id, opts \\ []) do
    optional_params = %{
      :allow_all_languages => :query,
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/users")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.UserInformationList{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end
