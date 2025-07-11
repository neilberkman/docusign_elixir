# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountUiSettings do
  @moduledoc """
  An object that defines the options that are available to non-administrators in the UI.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.AdminMessage
  alias DocuSign.Model.AskAnAdmin
  alias DocuSign.Model.SettingsMetadata

  @derive Jason.Encoder
  defstruct [
    :adminMessage,
    :allowUsersToEditSharedAccess,
    :allowUsersToEditSharedAccessMetadata,
    :askAnAdmin,
    :clickwrapSchemaVersion,
    :clickwrapSchemaVersionMetadata,
    :disableWebAppAccess,
    :disableWebAppAccessMetadata,
    :enableAdminMessage,
    :enableAdminMessageMetadata,
    :enableEasySignCanUseMultiTemplateApply,
    :enableEasySignCanUseMultiTemplateApplyMetadata,
    :enableEasySignTemplateUpload,
    :enableEasySignTemplateUploadMetadata,
    :enableEnvelopeCopyWithData,
    :enableEnvelopeCopyWithDataMetadata,
    :enableEnvelopeTypes,
    :enableEnvelopeTypesMetadata,
    :enableLegacySendflowLink,
    :enableLegacySendflowLinkMetadata,
    :hasExternalLinkedAccounts,
    :hasExternalLinkedAccountsMetadata,
    :hideSendAnEnvelope,
    :hideSendAnEnvelopeMetadata,
    :hideUseATemplate,
    :hideUseATemplateInPrepare,
    :hideUseATemplateInPrepareMetadata,
    :hideUseATemplateMetadata,
    :orderBasedRecipientIdGeneration,
    :orderBasedRecipientIdGenerationMetadata,
    :removeEnvelopeForwarding,
    :removeEnvelopeForwardingMetadata,
    :shouldRedactAccessCode,
    :shouldRedactAccessCodeMetadata,
    :uploadNewImageToSignOrInitial,
    :uploadNewImageToSignOrInitialMetadata
  ]

  @type t :: %__MODULE__{
          :adminMessage => AdminMessage.t() | nil,
          :allowUsersToEditSharedAccess => String.t() | nil,
          :allowUsersToEditSharedAccessMetadata => SettingsMetadata.t() | nil,
          :askAnAdmin => AskAnAdmin.t() | nil,
          :clickwrapSchemaVersion => String.t() | nil,
          :clickwrapSchemaVersionMetadata => SettingsMetadata.t() | nil,
          :disableWebAppAccess => String.t() | nil,
          :disableWebAppAccessMetadata => SettingsMetadata.t() | nil,
          :enableAdminMessage => String.t() | nil,
          :enableAdminMessageMetadata => SettingsMetadata.t() | nil,
          :enableEasySignCanUseMultiTemplateApply => String.t() | nil,
          :enableEasySignCanUseMultiTemplateApplyMetadata => SettingsMetadata.t() | nil,
          :enableEasySignTemplateUpload => String.t() | nil,
          :enableEasySignTemplateUploadMetadata => SettingsMetadata.t() | nil,
          :enableEnvelopeCopyWithData => String.t() | nil,
          :enableEnvelopeCopyWithDataMetadata => SettingsMetadata.t() | nil,
          :enableEnvelopeTypes => String.t() | nil,
          :enableEnvelopeTypesMetadata => SettingsMetadata.t() | nil,
          :enableLegacySendflowLink => String.t() | nil,
          :enableLegacySendflowLinkMetadata => SettingsMetadata.t() | nil,
          :hasExternalLinkedAccounts => String.t() | nil,
          :hasExternalLinkedAccountsMetadata => SettingsMetadata.t() | nil,
          :hideSendAnEnvelope => String.t() | nil,
          :hideSendAnEnvelopeMetadata => SettingsMetadata.t() | nil,
          :hideUseATemplate => String.t() | nil,
          :hideUseATemplateInPrepare => String.t() | nil,
          :hideUseATemplateInPrepareMetadata => SettingsMetadata.t() | nil,
          :hideUseATemplateMetadata => SettingsMetadata.t() | nil,
          :orderBasedRecipientIdGeneration => String.t() | nil,
          :orderBasedRecipientIdGenerationMetadata => SettingsMetadata.t() | nil,
          :removeEnvelopeForwarding => String.t() | nil,
          :removeEnvelopeForwardingMetadata => SettingsMetadata.t() | nil,
          :shouldRedactAccessCode => String.t() | nil,
          :shouldRedactAccessCodeMetadata => SettingsMetadata.t() | nil,
          :uploadNewImageToSignOrInitial => String.t() | nil,
          :uploadNewImageToSignOrInitialMetadata => SettingsMetadata.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:adminMessage, :struct, AdminMessage)
    |> Deserializer.deserialize(
      :allowUsersToEditSharedAccessMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(:askAnAdmin, :struct, AskAnAdmin)
    |> Deserializer.deserialize(
      :clickwrapSchemaVersionMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :disableWebAppAccessMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :enableAdminMessageMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :enableEasySignCanUseMultiTemplateApplyMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :enableEasySignTemplateUploadMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :enableEnvelopeCopyWithDataMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :enableEnvelopeTypesMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :enableLegacySendflowLinkMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :hasExternalLinkedAccountsMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :hideSendAnEnvelopeMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :hideUseATemplateInPrepareMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :hideUseATemplateMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :orderBasedRecipientIdGenerationMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :removeEnvelopeForwardingMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :shouldRedactAccessCodeMetadata,
      :struct,
      SettingsMetadata
    )
    |> Deserializer.deserialize(
      :uploadNewImageToSignOrInitialMetadata,
      :struct,
      SettingsMetadata
    )
  end
end
