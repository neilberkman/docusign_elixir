# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Templates do
  @moduledoc """
  Template management
  """

  @derive [Poison.Encoder]
  defstruct [
    :accessControlListBase64,
    :allowComments,
    :allowMarkup,
    :allowReassign,
    :allowViewHistory,
    :anySigner,
    :asynchronous,
    :attachmentsUri,
    :authoritativeCopy,
    :authoritativeCopyDefault,
    :autoMatch,
    :autoMatchSpecifiedByUser,
    :autoNavigation,
    :brandId,
    :brandLock,
    :certificateUri,
    :completedDateTime,
    :copyRecipientData,
    :created,
    :createdDateTime,
    :customFields,
    :customFieldsUri,
    :declinedDateTime,
    :deletedDateTime,
    :deliveredDateTime,
    :description,
    :disableResponsiveDocument,
    :documentBase64,
    :documents,
    :documentsCombinedUri,
    :documentsUri,
    :emailBlurb,
    :emailSettings,
    :emailSubject,
    :enableWetSign,
    :enforceSignerVisibility,
    :envelopeAttachments,
    :envelopeCustomMetadata,
    :envelopeDocuments,
    :envelopeId,
    :envelopeIdStamping,
    :envelopeLocation,
    :envelopeMetadata,
    :envelopeUri,
    :expireAfter,
    :expireDateTime,
    :expireEnabled,
    :externalEnvelopeId,
    :favoritedByMe,
    :folderId,
    :folderIds,
    :folderName,
    :folders,
    :hasComments,
    :hasFormDataChanged,
    :hasWavFile,
    :holder,
    :initialSentDateTime,
    :is21CFRPart11,
    :isDocGenTemplate,
    :isDynamicEnvelope,
    :isSignatureProviderEnvelope,
    :lastModified,
    :lastModifiedBy,
    :lastModifiedDateTime,
    :lastUsed,
    :location,
    :lockInformation,
    :messageLock,
    :name,
    :newPassword,
    :notification,
    :notificationUri,
    :owner,
    :pageCount,
    :password,
    :passwordProtected,
    :powerForm,
    :powerForms,
    :purgeCompletedDate,
    :purgeRequestDate,
    :purgeState,
    :recipients,
    :recipientsLock,
    :recipientsUri,
    :sender,
    :sentDateTime,
    :shared,
    :signerCanSignOnMobile,
    :signingLocation,
    :status,
    :statusChangedDateTime,
    :statusDateTime,
    :templateId,
    :templatesUri,
    :transactionId,
    :uri,
    :useDisclosure,
    :voidedDateTime,
    :voidedReason,
    :workflow
  ]

  @type t :: %__MODULE__{
          :accessControlListBase64 => String.t() | nil,
          :allowComments => String.t() | nil,
          :allowMarkup => String.t() | nil,
          :allowReassign => String.t() | nil,
          :allowViewHistory => String.t() | nil,
          :anySigner => String.t() | nil,
          :asynchronous => String.t() | nil,
          :attachmentsUri => String.t() | nil,
          :authoritativeCopy => String.t() | nil,
          :authoritativeCopyDefault => String.t() | nil,
          :autoMatch => String.t() | nil,
          :autoMatchSpecifiedByUser => String.t() | nil,
          :autoNavigation => String.t() | nil,
          :brandId => String.t() | nil,
          :brandLock => String.t() | nil,
          :certificateUri => String.t() | nil,
          :completedDateTime => String.t() | nil,
          :copyRecipientData => String.t() | nil,
          :created => String.t() | nil,
          :createdDateTime => String.t() | nil,
          :customFields => DocuSign.Model.AccountCustomFields.t() | nil,
          :customFieldsUri => String.t() | nil,
          :declinedDateTime => String.t() | nil,
          :deletedDateTime => String.t() | nil,
          :deliveredDateTime => String.t() | nil,
          :description => String.t() | nil,
          :disableResponsiveDocument => String.t() | nil,
          :documentBase64 => String.t() | nil,
          :documents => [DocuSign.Model.Document.t()] | nil,
          :documentsCombinedUri => String.t() | nil,
          :documentsUri => String.t() | nil,
          :emailBlurb => String.t() | nil,
          :emailSettings => DocuSign.Model.EmailSettings.t() | nil,
          :emailSubject => String.t() | nil,
          :enableWetSign => String.t() | nil,
          :enforceSignerVisibility => String.t() | nil,
          :envelopeAttachments => [DocuSign.Model.Attachment.t()] | nil,
          :envelopeCustomMetadata => DocuSign.Model.EnvelopeCustomMetadata.t() | nil,
          :envelopeDocuments => [DocuSign.Model.EnvelopeDocument.t()] | nil,
          :envelopeId => String.t() | nil,
          :envelopeIdStamping => String.t() | nil,
          :envelopeLocation => String.t() | nil,
          :envelopeMetadata => DocuSign.Model.EnvelopeMetadata.t() | nil,
          :envelopeUri => String.t() | nil,
          :expireAfter => String.t() | nil,
          :expireDateTime => String.t() | nil,
          :expireEnabled => String.t() | nil,
          :externalEnvelopeId => String.t() | nil,
          :favoritedByMe => String.t() | nil,
          :folderId => String.t() | nil,
          :folderIds => [String.t()] | nil,
          :folderName => String.t() | nil,
          :folders => [DocuSign.Model.Folder.t()] | nil,
          :hasComments => String.t() | nil,
          :hasFormDataChanged => String.t() | nil,
          :hasWavFile => String.t() | nil,
          :holder => String.t() | nil,
          :initialSentDateTime => String.t() | nil,
          :is21CFRPart11 => String.t() | nil,
          :isDocGenTemplate => String.t() | nil,
          :isDynamicEnvelope => String.t() | nil,
          :isSignatureProviderEnvelope => String.t() | nil,
          :lastModified => String.t() | nil,
          :lastModifiedBy => DocuSign.Model.UserInfo.t() | nil,
          :lastModifiedDateTime => String.t() | nil,
          :lastUsed => String.t() | nil,
          :location => String.t() | nil,
          :lockInformation => DocuSign.Model.EnvelopeLocks.t() | nil,
          :messageLock => String.t() | nil,
          :name => String.t() | nil,
          :newPassword => String.t() | nil,
          :notification => DocuSign.Model.Notification.t() | nil,
          :notificationUri => String.t() | nil,
          :owner => DocuSign.Model.UserInfo.t() | nil,
          :pageCount => String.t() | nil,
          :password => String.t() | nil,
          :passwordProtected => String.t() | nil,
          :powerForm => DocuSign.Model.PowerForm.t() | nil,
          :powerForms => [DocuSign.Model.PowerForm.t()] | nil,
          :purgeCompletedDate => String.t() | nil,
          :purgeRequestDate => String.t() | nil,
          :purgeState => String.t() | nil,
          :recipients => DocuSign.Model.EnvelopeRecipients.t() | nil,
          :recipientsLock => String.t() | nil,
          :recipientsUri => String.t() | nil,
          :sender => DocuSign.Model.UserInfo.t() | nil,
          :sentDateTime => String.t() | nil,
          :shared => String.t() | nil,
          :signerCanSignOnMobile => String.t() | nil,
          :signingLocation => String.t() | nil,
          :status => String.t() | nil,
          :statusChangedDateTime => String.t() | nil,
          :statusDateTime => String.t() | nil,
          :templateId => String.t() | nil,
          :templatesUri => String.t() | nil,
          :transactionId => String.t() | nil,
          :uri => String.t() | nil,
          :useDisclosure => String.t() | nil,
          :voidedDateTime => String.t() | nil,
          :voidedReason => String.t() | nil,
          :workflow => DocuSign.Model.Workflow.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.Templates do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:customFields, :struct, DocuSign.Model.AccountCustomFields, options)
    |> deserialize(:documents, :list, DocuSign.Model.Document, options)
    |> deserialize(:emailSettings, :struct, DocuSign.Model.EmailSettings, options)
    |> deserialize(:envelopeAttachments, :list, DocuSign.Model.Attachment, options)
    |> deserialize(
      :envelopeCustomMetadata,
      :struct,
      DocuSign.Model.EnvelopeCustomMetadata,
      options
    )
    |> deserialize(:envelopeDocuments, :list, DocuSign.Model.EnvelopeDocument, options)
    |> deserialize(:envelopeMetadata, :struct, DocuSign.Model.EnvelopeMetadata, options)
    |> deserialize(:folders, :list, DocuSign.Model.Folder, options)
    |> deserialize(:lastModifiedBy, :struct, DocuSign.Model.UserInfo, options)
    |> deserialize(:lockInformation, :struct, DocuSign.Model.EnvelopeLocks, options)
    |> deserialize(:notification, :struct, DocuSign.Model.Notification, options)
    |> deserialize(:owner, :struct, DocuSign.Model.UserInfo, options)
    |> deserialize(:powerForm, :struct, DocuSign.Model.PowerForm, options)
    |> deserialize(:powerForms, :list, DocuSign.Model.PowerForm, options)
    |> deserialize(:recipients, :struct, DocuSign.Model.EnvelopeRecipients, options)
    |> deserialize(:sender, :struct, DocuSign.Model.UserInfo, options)
    |> deserialize(:workflow, :struct, DocuSign.Model.Workflow, options)
  end
end
