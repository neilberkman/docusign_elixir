defmodule DocuSign.User do
  @moduledoc """
  This module contains the User struct and functions for working with it.

  ### Examples

  client = DocuSign.Client.get_token!
  user_info = DocuSign.User.info(client)

  or

  user_info = DocuSign.User.info()
  """

  defstruct [
    # The user ID of the account holder
    :sub,
    # The name of the account holder
    :name,
    # The given name of the account holder
    :given_name,
    # The family name of the account holder
    :family_name,
    # The DateTime when the account was created
    :created,
    # The email address of the account holder
    :email,
    # Holds data on the individual accounts owned by the user. Each user may possess multiple accounts.
    :accounts,
    # The ID of the account.
    :account_id,
    # If true, this account is the account holder's default account.
    :is_default,
    # The name associated with this account.
    :account_name,
    # The base URI that is used for making API calls on behalf of this account.
    :base_uri,
    # Holds data on the organization to which this account belongs.
    :organization,
    # The ID of the organization to which this account belongs.
    :organization_id,
    # Holds a link to the organization's base URL.
    :links
  ]

  alias OAuth2.Client
  alias DocuSign.{APIClient, Util}

  @path "/oauth/userinfo"

  def info(client \\ nil) do
    with api_client <- client || APIClient.client(),
         {:ok, %{body: body}} <- Client.get(api_client, @path),
         attrs <- Util.map_keys_to_atoms(body),
         do: struct(__MODULE__, attrs)
  end
end
