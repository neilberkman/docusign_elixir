# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.UserAccountManagementGranularInformation do
  @moduledoc """
  Describes which account management capabilities a user has.
  """

  @derive [Poison.Encoder]
  defstruct [
    :canManageAccountSecuritySettings,
    :canManageAccountSecuritySettingsMetadata,
    :canManageAccountSettings,
    :canManageAccountSettingsMetadata,
    :canManageAdmins,
    :canManageAdminsMetadata,
    :canManageGroups,
    :canManageGroupsMetadata,
    :canManageReporting,
    :canManageReportingMetadata,
    :canManageSharing,
    :canManageSharingMetadata,
    :canManageSigningGroups,
    :canManageSigningGroupsMetadata,
    :canManageUsers,
    :canManageUsersMetadata
  ]

  @type t :: %__MODULE__{
          :canManageAccountSecuritySettings => String.t(),
          :canManageAccountSecuritySettingsMetadata => SettingsMetadata,
          :canManageAccountSettings => String.t(),
          :canManageAccountSettingsMetadata => SettingsMetadata,
          :canManageAdmins => String.t(),
          :canManageAdminsMetadata => SettingsMetadata,
          :canManageGroups => String.t(),
          :canManageGroupsMetadata => SettingsMetadata,
          :canManageReporting => String.t(),
          :canManageReportingMetadata => SettingsMetadata,
          :canManageSharing => String.t(),
          :canManageSharingMetadata => SettingsMetadata,
          :canManageSigningGroups => String.t(),
          :canManageSigningGroupsMetadata => SettingsMetadata,
          :canManageUsers => String.t(),
          :canManageUsersMetadata => SettingsMetadata
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.UserAccountManagementGranularInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :canManageAccountSecuritySettingsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :canManageAccountSettingsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(:canManageAdminsMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(:canManageGroupsMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(:canManageReportingMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(:canManageSharingMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(
      :canManageSigningGroupsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(:canManageUsersMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
  end
end
