defmodule DocuSign.User do
  @moduledoc """
  This module contains the User struct and functions for working with it.

  ### Examples

  client = DocuSign.OAuth2Strategy.get_token!
  user_info = DocuSign.User.info(client)

  """

  defstruct [
    :sub, #The user ID of the account holder
    :name, #The name of the account holder
    :given_name, #The given name of the account holder
    :family_name, #The family name of the account holder
    :created, #The DateTime when the account was created
    :email, #The email address of the account holder
    :accounts, #Holds data on the individual accounts owned by the user. Each user may possess multiple accounts.
    :account_id, #The ID of the account.
    :is_default, #If true, this account is the account holder's default account.
    :account_name, #The name associated with this account.
    :base_uri, #The base URI that is used for making API calls on behalf of this account.
    :organization, #Holds data on the organization to which this account belongs.
    :organization_id, #The ID of the organization to which this account belongs.
    :links #Holds a link to the organization's base URL.
  ]

  alias OAuth2.Client
  alias DocuSign.Util

  @path "/oauth/userinfo"

  def info(client) do
    with {:ok, %{body: body}} <- Client.get(client, @path),
         attrs <- Util.map_keys_to_atoms(body),
      do: struct(__MODULE__, attrs)
  end
end
