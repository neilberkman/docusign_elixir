# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Group do
  @moduledoc """
  This object contains information about a group.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.ErrorDetails
  alias DocuSign.Model.UserInfo

  @derive Jason.Encoder
  defstruct [
    :accessType,
    :dsGroupId,
    :errorDetails,
    :groupId,
    :groupName,
    :groupType,
    :isManagedByScim,
    :lastModifiedOn,
    :permissionProfileId,
    :users,
    :usersCount
  ]

  @type t :: %__MODULE__{
          :accessType => String.t() | nil,
          :dsGroupId => String.t() | nil,
          :errorDetails => ErrorDetails.t() | nil,
          :groupId => String.t() | nil,
          :groupName => String.t() | nil,
          :groupType => String.t() | nil,
          :isManagedByScim => String.t() | nil,
          :lastModifiedOn => String.t() | nil,
          :permissionProfileId => String.t() | nil,
          :users => [UserInfo.t()] | nil,
          :usersCount => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, ErrorDetails)
    |> Deserializer.deserialize(:users, :list, UserInfo)
  end
end
