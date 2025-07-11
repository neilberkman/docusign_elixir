# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.Accounts do
  @moduledoc """
  API calls for all endpoints tagged `Accounts`.
  """

  import DocuSign.RequestBuilder

  alias DocuSign.Connection
  alias DocuSign.Model.AccountInformation
  alias DocuSign.Model.AccountSettingsInformation
  alias DocuSign.Model.AccountSharedAccess
  alias DocuSign.Model.BillingChargeResponse
  alias DocuSign.Model.CaptiveRecipientInformation
  alias DocuSign.Model.EnvelopePurgeConfiguration
  alias DocuSign.Model.ErrorDetails
  alias DocuSign.Model.FileTypeList
  alias DocuSign.Model.NewAccountSummary
  alias DocuSign.Model.NotificationDefaults
  alias DocuSign.Model.ProvisioningInformation
  alias DocuSign.Model.RecipientNamesResponse
  alias DocuSign.Model.SupportedLanguages

  @doc """
  Deletes the specified account.
  This closes the specified account. You must be an account admin to close your account. Once closed, an account must be reopened by Docusign.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:redact_user_data` (String.t):

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec accounts_delete_account(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil} | {:ok, ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def accounts_delete_account(connection, account_id, opts \\ []) do
    optional_params = %{
      :redact_user_data => :query
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Retrieves the account information for the specified account.
  Retrieves the account information for the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:include_account_settings` (String.t): When **true,** includes account settings in the response. The default value is **false.**

  ### Returns

  - `{:ok, DocuSign.Model.AccountInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec accounts_get_account(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, AccountInformation.t()}
          | {:error, Tesla.Env.t()}
  def accounts_get_account(connection, account_id, opts \\ []) do
    optional_params = %{
      :include_account_settings => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, AccountInformation},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Retrieves the account provisioning information for the account.
  Retrieves the account provisioning information for the account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.ProvisioningInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec accounts_get_provisioning(Tesla.Env.client(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, ProvisioningInformation.t()}
          | {:error, Tesla.Env.t()}
  def accounts_get_provisioning(connection, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/provisioning")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, ProvisioningInformation},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Creates new accounts.
  Creates new Docusign accounts. You can use this method to create a single account or up to 100 accounts at a time.  **Note:**  This method is restricted to partner integrations. You must work with Docusign Professional Services or Docusign Business Development, who will provide you with the Distributor Code and Distributor Password that you need to include in the request body.   When creating a single account, the body of the request is a [`newAccountRequest`][newAccountRequest] object.  Example:  ``` {   \"newAccountRequest\": [     {       \"accountName\":\"Test Account\",       \"distributorCode\":\"MY_DIST_CODE\",       \"distributorPassword\":\"MY_DIST_PWD\",       \"initialUser\":{         \"email\":\"user@emaildomain.com\",         \"firstName\":\"John\",         \"middleName\": \"Harry\",         \"lastName\":\"Doe\",         \"suffixName\": \"\",         \"userName\": \"John Doe\",         \"jobTitle\": \"Engineer\",         \"company\": \"Test Company\"       },       \"addressInformation\":{         \"address1\": \"1234 Main Street\",         \"address2\": \"Suite 100\",         \"city\": \"Seattle\",         \"state\": \"WA\",         \"postalCode\": \"98101\",         \"country\": \"US\",         \"phone\": \"1234567890\",         \"fax\": \"1234567891\"       },       \"planInformation\":{         \"planId\":\"37085696-xxxx-xxxx-xxxx-7ea067752959\"       },       \"referralInformation\":{         \"includedSeats\": \"1\",         \"referralCode\": \"code\",         \"referrerName\": \"name\"       }     }   ] }  ``` If the request succeeds, it returns a 201 (Created) HTTP response code. The response returns the new account ID, password, and the default user information for each newly created account.   When creating multiple accounts, the body of the request is a `newAccountRequests` object, which contains one or more [`newAccountDefinition`][newAccountDefinition] objects. You can create up to 100 new accounts at a time this way.  The body for a multi-account creation request looks like this in JSON:  ``` {   \"newAccountRequests\": [     {       \"accountName\": \"accountone\",       . . .     },     {       \"accountName\": \"accounttwo\",       . . .     }   ] } ```  A multi-account request looks like this in XML:  ``` <newAccountsDefinition xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.docusign.com/restapi\">   <newAccountRequests>     <newAccountDefinition>       . . .     </newAccountDefinition>     <newAccountDefinition>       . . .     </newAccountDefinition>   </newAccountRequests> </newAccountsDefinition> ```  A multi-account creation request may succeed (report a 201 code) even if some accounts could not be created. In this case, the `errorDetails` property in the response contains specific information about the failure.    [newAccountDefinition]: #/definitions/newAccountDefinition [nameValue]: #/definitions/nameValue [newAccountRequest]: #/definitions/newAccountRequest

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `opts` (keyword): Optional parameters
    - `:body` (NewAccountDefinition):

  ### Returns

  - `{:ok, DocuSign.Model.NewAccountSummary.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec accounts_post_accounts(Tesla.Env.client(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, NewAccountSummary.t()}
          | {:error, Tesla.Env.t()}
  def accounts_post_accounts(connection, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, NewAccountSummary},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets list of recurring and usage charges for the account.
  Retrieves the list of recurring and usage charges for the account. This can be used to determine the charge structure and usage of charge plan items.   Privileges required: account administrator

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:include_charges` (String.t): Specifies which billing charges to return. Valid values are:  * envelopes * seats

  ### Returns

  - `{:ok, DocuSign.Model.BillingChargeResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec billing_charges_get_account_billing_charges(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, BillingChargeResponse.t()}
          | {:error, Tesla.Env.t()}
  def billing_charges_get_account_billing_charges(connection, account_id, opts \\ []) do
    optional_params = %{
      :include_charges => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/billing_charges")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, BillingChargeResponse},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Deletes the signature for one or more captive recipient records.
  This method deletes the signature for one or more captive recipient records. It is primarily used for testing. This functionality provides a way to reset the signature associated with a client user ID so that a new signature can be created the next time the client user ID is used.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `recipient_part` (String.t): Signature is the only supported value.
  - `opts` (keyword): Optional parameters
    - `:body` (CaptiveRecipientInformation):

  ### Returns

  - `{:ok, DocuSign.Model.CaptiveRecipientInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec captive_recipients_delete_captive_recipients_part(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, CaptiveRecipientInformation.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def captive_recipients_delete_captive_recipients_part(connection, account_id, recipient_part, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/captive_recipients/#{recipient_part}")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, CaptiveRecipientInformation},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets the envelope purge configuration for an account.
  An envelope purge configuration enables account administrators to permanently remove documents and their field data from completed and voided envelopes after a specified retention period (`retentionDays`). This method retrieves the current envelope purge configuration for your account.  **Note:** To use this method, you must be an account administrator.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopePurgeConfiguration.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec envelope_purge_configuration_get_envelope_purge_configuration(
          Tesla.Env.client(),
          String.t(),
          keyword()
        ) ::
          {:ok, ErrorDetails.t()}
          | {:ok, EnvelopePurgeConfiguration.t()}
          | {:error, Tesla.Env.t()}
  def envelope_purge_configuration_get_envelope_purge_configuration(connection, account_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/settings/envelope_purge_configuration")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, EnvelopePurgeConfiguration},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Sets the envelope purge configuration for an account.
  An envelope purge configuration enables account administrators to permanently remove documents and their field data from completed and voided envelopes after a specified retention period (`retentionDays`). This method sets the envelope purge configuration for your account.  **Note:** To use this method, you must be an account administrator.  For more information, see [Purge Envelopes](https://support.docusign.com/s/document-item?bundleId=oeq1643226594604&topicId=edo1578456348066.html).

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (EnvelopePurgeConfiguration):

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopePurgeConfiguration.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec envelope_purge_configuration_put_envelope_purge_configuration(
          Tesla.Env.client(),
          String.t(),
          keyword()
        ) ::
          {:ok, ErrorDetails.t()}
          | {:ok, EnvelopePurgeConfiguration.t()}
          | {:error, Tesla.Env.t()}
  def envelope_purge_configuration_put_envelope_purge_configuration(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/settings/envelope_purge_configuration")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, EnvelopePurgeConfiguration},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets envelope notification defaults.
  This method returns the default settings for the email notifications that signers and senders receive about envelopes.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.NotificationDefaults.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec notification_defaults_get_notification_defaults(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, NotificationDefaults.t()}
          | {:error, Tesla.Env.t()}
  def notification_defaults_get_notification_defaults(connection, account_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/settings/notification_defaults")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, NotificationDefaults},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Updates envelope notification default settings.
  This method changes the default settings for the email notifications that signers and senders receive about envelopes.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (NotificationDefaults):

  ### Returns

  - `{:ok, DocuSign.Model.NotificationDefaults.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec notification_defaults_put_notification_defaults(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, NotificationDefaults.t()}
          | {:error, Tesla.Env.t()}
  def notification_defaults_put_notification_defaults(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/settings/notification_defaults")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, NotificationDefaults},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets the recipient names associated with an email address.
  Retrieves a list of all of the names associated with the email address that you pass in. This list can include variants of a single recipient's name that are used for signing, as well as the names of multiple different recipients.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:email` (String.t): (Required) The email address for which you want to retrieve recipient names.

  ### Returns

  - `{:ok, DocuSign.Model.RecipientNamesResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec recipient_names_get_recipient_names(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, RecipientNamesResponse.t()}
          | {:error, Tesla.Env.t()}
  def recipient_names_get_recipient_names(connection, account_id, opts \\ []) do
    optional_params = %{
      :email => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/recipient_names")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, RecipientNamesResponse},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets account settings information.
  Retrieves the account settings information for the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.AccountSettingsInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec settings_get_settings(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, AccountSettingsInformation.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def settings_get_settings(connection, account_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/settings")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, AccountSettingsInformation},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Updates the account settings for an account.
  Updates the account settings for the specified account.  Although the request body for this method is a complete `accountSettingsInformation` object, you only need to provide the properties that you are updating.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (AccountSettingsInformation):

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec settings_put_settings(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil} | {:ok, ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def settings_put_settings(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/settings")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Reserved: Gets the shared item status for one or more users.
  Retrieves shared item status for one or more users and types of items.  Users with account administration privileges can retrieve shared access information for all account users. Users without account administrator privileges can only retrieve shared access information for themselves, and the returned information is limited to retrieving the status of the members of the account that are sharing their folders to the user. This is equivalent to setting the `shared` parameter to `shared_from`.  **Note:** This endpoint returns the shared status for the legacy Shared Envelopes feature. To use the new Shared Access feature, use the [Authorizations resource](/docs/esign-rest-api/reference/accounts/authorizations/).  ### Related topics  - [How to share access to a Docusign envelope inbox](/docs/esign-rest-api/how-to/shared-access/)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:count` (String.t): The maximum number of results to return.  Use `start_position` to specify the number of results to skip.  Default: `1000`
    - `:envelopes_not_shared_user_status` (String.t): This query parameter works in conjunction with `user_ids`. When you specify one of the following user statuses, the query limits the results to only users that match the specified status: - `ActivationRequired`: Membership Activation required - `ActivationSent`: Membership activation sent to user - `Active`: User Membership is active - `Closed`: User Membership is closed - `Disabled`: User Membership is disabled
    - `:folder_ids` (String.t): A comma-separated list of folder IDs for which to return shared item information. If `item_type` is set to `folders`, at least one folder ID is required.
    - `:item_type` (String.t): Specifies the type of shared item being requested. Valid values:  - `envelopes`: Get information about envelope sharing between users. - `templates`: Get information about template sharing among users and groups. - `folders`: Get information about folder sharing among users and groups.
    - `:search_text` (String.t): Filter user names based on the specified string. The wild-card '*' (asterisk) can be used in the string.
    - `:shared` (String.t): A comma-separated list of sharing filters that specifies which users appear in the response.   - `not_shared`: The response lists users who do not share items of `item_type` with the current user.  - `shared_to`: The response lists users in `user_list` who are sharing items to current user.  - `shared_from`: The response lists users in `user_list` who are sharing items from the current user.  - `shared_to_and_from`: The response lists users in `user_list` who are sharing items to and from the current user.  If the current user does not have administrative privileges, only the `shared_to` option is valid.
    - `:start_position` (String.t): The zero-based index of the result from which to start returning results.  Use with `count` to limit the number of results.  The default value is `0`.
    - `:user_ids` (String.t): A comma-separated list of user IDs for whom the shared item information is being requested.

  ### Returns

  - `{:ok, DocuSign.Model.AccountSharedAccess.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec shared_access_get_shared_access(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, AccountSharedAccess.t()}
          | {:error, Tesla.Env.t()}
  def shared_access_get_shared_access(connection, account_id, opts \\ []) do
    optional_params = %{
      :count => :query,
      :envelopes_not_shared_user_status => :query,
      :folder_ids => :query,
      :item_type => :query,
      :search_text => :query,
      :shared => :query,
      :start_position => :query,
      :user_ids => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/shared_access")
      |> add_optional_params(optional_params, opts)
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, AccountSharedAccess},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Reserved: Sets the shared access information for users.
  This sets the shared access status for one or more users or templates.  When setting user shared access, only users with account administration privileges can set shared access status for envelopes.  When setting template shared access, only users who own a template and have sharing permission or with account administration privileges can set shared access for templates.  Changes to the shared items status are not additive. The change always replaces the current status.  To change template shared access, add the query parameter `item_type` = `templates` to the request. When this is set, the user and envelopes properties are not required.  **Note:** This functionality is a newer version of the [Update Group Share](/docs/esign-rest-api/reference/templates/templates/updategroupshare/) functionality.  ### Related topics  - [How to share access to a Docusign envelope inbox](/docs/esign-rest-api/how-to/shared-access/)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:item_type` (String.t): Specifies the type of shared item being set: - `envelopes`: Set envelope sharing between users. - `templates`: Set information about template sharing among users and groups. - `folders`: Get information about folder sharing among users and groups.
    - `:preserve_existing_shared_access` (String.t): When **true,** preserve the existing shared access settings.
    - `:user_ids` (String.t): A comma-separated list of IDs for users whose shared item access is being set.
    - `:body` (AccountSharedAccess):

  ### Returns

  - `{:ok, DocuSign.Model.AccountSharedAccess.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec shared_access_put_shared_access(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, AccountSharedAccess.t()}
          | {:error, Tesla.Env.t()}
  def shared_access_put_shared_access(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body,
      :item_type => :query,
      :preserve_existing_shared_access => :query,
      :user_ids => :query
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/shared_access")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, AccountSharedAccess},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets the supported languages for envelope recipients.
  Retrieves a list of supported languages that you can set for an individual recipient when creating an envelope, as well as their simple type enumeration values. These are the languages that you can set for the standard email format and signing view for each recipient.  For example, in the recipient's email notification, this setting affects elements such as the standard introductory text describing the request to sign. It also determines the language used for buttons and tabs in both the email notification and the signing experience.  **Note:** Setting a language for a recipient affects only the Docusign standard text. Any custom text that you enter for the `emailBody` and `emailSubject` of the notification is not translated, and appears exactly as you enter it.  For more information, see [Set Recipient Language and Specify Custom Email Messages](https://support.docusign.com/s/document-item?bundleId=gbo1643332197980&topicId=wxf1578456494201.html).

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.SupportedLanguages.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec supported_languages_get_supported_languages(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, ErrorDetails.t()}
          | {:ok, SupportedLanguages.t()}
          | {:error, Tesla.Env.t()}
  def supported_languages_get_supported_languages(connection, account_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/supported_languages")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, SupportedLanguages},
      {400, ErrorDetails}
    ])
  end

  @doc """
  Gets a list of unsupported file types.
  Retrieves a list of file types (mime-types and file-extensions) that are not supported for upload through the Docusign system.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.FileTypeList.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec unsupported_file_types_get_unsupported_file_types(
          Tesla.Env.client(),
          String.t(),
          keyword()
        ) ::
          {:ok, FileTypeList.t()}
          | {:ok, ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def unsupported_file_types_get_unsupported_file_types(connection, account_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/unsupported_file_types")
      |> Enum.to_list()

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, FileTypeList},
      {400, ErrorDetails}
    ])
  end
end
