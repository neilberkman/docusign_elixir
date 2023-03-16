# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountRoleSettings do
  @moduledoc """
  This object defines account permissions for users who are associated with the account permission profile.
  """

  @derive [Poison.Encoder]
  defstruct [
    :allowAccountManagement,
    :allowAccountManagementMetadata,
    :allowApiAccess,
    :allowApiAccessMetadata,
    :allowApiAccessToAccount,
    :allowApiAccessToAccountMetadata,
    :allowApiSendingOnBehalfOfOthers,
    :allowApiSendingOnBehalfOfOthersMetadata,
    :allowApiSequentialSigning,
    :allowApiSequentialSigningMetadata,
    :allowAutoTagging,
    :allowAutoTaggingMetadata,
    :allowBulkSending,
    :allowBulkSendingMetadata,
    :allowDocuSignDesktopClient,
    :allowDocuSignDesktopClientMetadata,
    :allowedAddressBookAccess,
    :allowedAddressBookAccessMetadata,
    :allowedClickwrapsAccess,
    :allowedClickwrapsAccessMetadata,
    :allowedTemplateAccess,
    :allowedTemplateAccessMetadata,
    :allowedToBeEnvelopeTransferRecipient,
    :allowedToBeEnvelopeTransferRecipientMetadata,
    :allowEnvelopeSending,
    :allowEnvelopeSendingMetadata,
    :allowESealRecipients,
    :allowESealRecipientsMetadata,
    :allowPowerFormsAdminToAccessAllPowerFormEnvelopes,
    :allowPowerFormsAdminToAccessAllPowerFormEnvelopesMetadata,
    :allowSendersToSetRecipientEmailLanguage,
    :allowSendersToSetRecipientEmailLanguageMetadata,
    :allowSignerAttachments,
    :allowSignerAttachmentsMetadata,
    :allowSupplementalDocuments,
    :allowSupplementalDocumentsMetadata,
    :allowTaggingInSendAndCorrect,
    :allowTaggingInSendAndCorrectMetadata,
    :allowVaulting,
    :allowVaultingMetadata,
    :allowWetSigningOverride,
    :allowWetSigningOverrideMetadata,
    :canCreateWorkspaces,
    :canCreateWorkspacesMetadata,
    :canSendEnvelopesViaSMS,
    :canSendEnvelopesViaSMSMetadata,
    :disableDocumentUpload,
    :disableDocumentUploadMetadata,
    :disableOtherActions,
    :disableOtherActionsMetadata,
    :enableApiRequestLogging,
    :enableApiRequestLoggingMetadata,
    :enableKeyTermsSuggestionsByDocumentType,
    :enableKeyTermsSuggestionsByDocumentTypeMetadata,
    :enableRecipientViewingNotifications,
    :enableRecipientViewingNotificationsMetadata,
    :enableSequentialSigningInterface,
    :enableSequentialSigningInterfaceMetadata,
    :enableTransactionPointIntegration,
    :enableTransactionPointIntegrationMetadata,
    :powerFormRole,
    :powerFormRoleMetadata,
    :receiveCompletedSelfSignedDocumentsAsEmailLinks,
    :receiveCompletedSelfSignedDocumentsAsEmailLinksMetadata,
    :signingUiVersionMetadata,
    :supplementalDocumentsMustAccept,
    :supplementalDocumentsMustAcceptMetadata,
    :supplementalDocumentsMustRead,
    :supplementalDocumentsMustReadMetadata,
    :supplementalDocumentsMustView,
    :supplementalDocumentsMustViewMetadata,
    :useNewDocuSignExperienceInterface,
    :useNewDocuSignExperienceInterfaceMetadata,
    :useNewSendingInterface,
    :useNewSendingInterfaceMetadata,
    :vaultingMode,
    :vaultingModeMetadata,
    :webForms,
    :webFormsMetadata
  ]

  @type t :: %__MODULE__{
          :allowAccountManagement => String.t() | nil,
          :allowAccountManagementMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowApiAccess => String.t() | nil,
          :allowApiAccessMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowApiAccessToAccount => String.t() | nil,
          :allowApiAccessToAccountMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowApiSendingOnBehalfOfOthers => String.t() | nil,
          :allowApiSendingOnBehalfOfOthersMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowApiSequentialSigning => String.t() | nil,
          :allowApiSequentialSigningMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowAutoTagging => String.t() | nil,
          :allowAutoTaggingMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowBulkSending => String.t() | nil,
          :allowBulkSendingMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowDocuSignDesktopClient => String.t() | nil,
          :allowDocuSignDesktopClientMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowedAddressBookAccess => String.t() | nil,
          :allowedAddressBookAccessMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowedClickwrapsAccess => String.t() | nil,
          :allowedClickwrapsAccessMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowedTemplateAccess => String.t() | nil,
          :allowedTemplateAccessMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowedToBeEnvelopeTransferRecipient => String.t() | nil,
          :allowedToBeEnvelopeTransferRecipientMetadata =>
            DocuSign.Model.SettingsMetadata.t() | nil,
          :allowEnvelopeSending => String.t() | nil,
          :allowEnvelopeSendingMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowESealRecipients => String.t() | nil,
          :allowESealRecipientsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowPowerFormsAdminToAccessAllPowerFormEnvelopes => String.t() | nil,
          :allowPowerFormsAdminToAccessAllPowerFormEnvelopesMetadata =>
            DocuSign.Model.SettingsMetadata.t() | nil,
          :allowSendersToSetRecipientEmailLanguage => String.t() | nil,
          :allowSendersToSetRecipientEmailLanguageMetadata =>
            DocuSign.Model.SettingsMetadata.t() | nil,
          :allowSignerAttachments => String.t() | nil,
          :allowSignerAttachmentsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowSupplementalDocuments => String.t() | nil,
          :allowSupplementalDocumentsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowTaggingInSendAndCorrect => String.t() | nil,
          :allowTaggingInSendAndCorrectMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowVaulting => String.t() | nil,
          :allowVaultingMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :allowWetSigningOverride => String.t() | nil,
          :allowWetSigningOverrideMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :canCreateWorkspaces => String.t() | nil,
          :canCreateWorkspacesMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :canSendEnvelopesViaSMS => String.t() | nil,
          :canSendEnvelopesViaSMSMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :disableDocumentUpload => String.t() | nil,
          :disableDocumentUploadMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :disableOtherActions => String.t() | nil,
          :disableOtherActionsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :enableApiRequestLogging => String.t() | nil,
          :enableApiRequestLoggingMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :enableKeyTermsSuggestionsByDocumentType => String.t() | nil,
          :enableKeyTermsSuggestionsByDocumentTypeMetadata =>
            DocuSign.Model.SettingsMetadata.t() | nil,
          :enableRecipientViewingNotifications => String.t() | nil,
          :enableRecipientViewingNotificationsMetadata =>
            DocuSign.Model.SettingsMetadata.t() | nil,
          :enableSequentialSigningInterface => String.t() | nil,
          :enableSequentialSigningInterfaceMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :enableTransactionPointIntegration => String.t() | nil,
          :enableTransactionPointIntegrationMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :powerFormRole => String.t() | nil,
          :powerFormRoleMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :receiveCompletedSelfSignedDocumentsAsEmailLinks => String.t() | nil,
          :receiveCompletedSelfSignedDocumentsAsEmailLinksMetadata =>
            DocuSign.Model.SettingsMetadata.t() | nil,
          :signingUiVersionMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :supplementalDocumentsMustAccept => String.t() | nil,
          :supplementalDocumentsMustAcceptMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :supplementalDocumentsMustRead => String.t() | nil,
          :supplementalDocumentsMustReadMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :supplementalDocumentsMustView => String.t() | nil,
          :supplementalDocumentsMustViewMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :useNewDocuSignExperienceInterface => String.t() | nil,
          :useNewDocuSignExperienceInterfaceMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :useNewSendingInterface => String.t() | nil,
          :useNewSendingInterfaceMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :vaultingMode => String.t() | nil,
          :vaultingModeMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :webForms => String.t() | nil,
          :webFormsMetadata => DocuSign.Model.SettingsMetadata.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.AccountRoleSettings do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :allowAccountManagementMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(:allowApiAccessMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(
      :allowApiAccessToAccountMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowApiSendingOnBehalfOfOthersMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowApiSequentialSigningMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(:allowAutoTaggingMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(:allowBulkSendingMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(
      :allowDocuSignDesktopClientMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowedAddressBookAccessMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowedClickwrapsAccessMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowedTemplateAccessMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowedToBeEnvelopeTransferRecipientMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowEnvelopeSendingMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowESealRecipientsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowPowerFormsAdminToAccessAllPowerFormEnvelopesMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowSendersToSetRecipientEmailLanguageMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowSignerAttachmentsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowSupplementalDocumentsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :allowTaggingInSendAndCorrectMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(:allowVaultingMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(
      :allowWetSigningOverrideMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :canCreateWorkspacesMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :canSendEnvelopesViaSMSMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :disableDocumentUploadMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :disableOtherActionsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :enableApiRequestLoggingMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :enableKeyTermsSuggestionsByDocumentTypeMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :enableRecipientViewingNotificationsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :enableSequentialSigningInterfaceMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :enableTransactionPointIntegrationMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(:powerFormRoleMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(
      :receiveCompletedSelfSignedDocumentsAsEmailLinksMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(:signingUiVersionMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(
      :supplementalDocumentsMustAcceptMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :supplementalDocumentsMustReadMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :supplementalDocumentsMustViewMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :useNewDocuSignExperienceInterfaceMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(
      :useNewSendingInterfaceMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata,
      options
    )
    |> deserialize(:vaultingModeMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
    |> deserialize(:webFormsMetadata, :struct, DocuSign.Model.SettingsMetadata, options)
  end
end
