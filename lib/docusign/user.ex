defmodule DocuSign.User do
  @moduledoc """
  This module contains the User struct and functions for working with it.

  ### Examples

  client = DocuSign.Client.get_token!
  user_info = DocuSign.User.info(client)

  or

  user_info = DocuSign.User.info()
  """

  alias __MODULE__

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
    # Holds data on the individual accounts owned by the user.
    # Each user may possess multiple accounts.
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

  alias DocuSign.Util

  defmodule AppAccount do
    @moduledoc false
    defstruct [:account_id, :account_name, :base_uri, :is_default]
    @type t :: %__MODULE__{}
  end

  @doc """
  Retrieve the user info
  """
  def info(client) do
    body = oauth_implementation().get_client_info(client)
    attrs = Util.map_keys_to_atoms(body)

    __MODULE__
    |> struct(attrs)
    |> Map.update!(:accounts, fn accounts ->
      Enum.map(accounts, &struct(AppAccount, Util.map_keys_to_atoms(&1)))
    end)
  end

  @doc """
  Retrieve default account is exist
  """
  def default_account(%User{accounts: accounts} = _info) do
    default_account(accounts)
  end

  def default_account(accounts), do: Enum.find(accounts, & &1.is_default)

  defp oauth_implementation do
    Application.get_env(:docusign, :oauth_implementation, DocuSign.OAuth.Impl)
  end
end
