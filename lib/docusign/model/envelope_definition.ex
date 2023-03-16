# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeDefinition do
  @moduledoc """
  Envelope object definition.
  """

  @derive [Poison.Encoder]
  defstruct [
    :accessControlListBase64,
    :accessibility,
    :allowComments,
    :allowMarkup,
    :allowReassign,
    :allowRecipientRecursion,
    :allowViewHistory,
    :anySigner,
    :asynchronous,
    :attachments,
    :attachmentsUri,
    :authoritativeCopy,
    :authoritativeCopyDefault,
    :autoNavigation,
    :brandId,
    :brandLock,
    :certificateUri,
    :completedDateTime,
    :compositeTemplates,
    :copyRecipientData,
    :createdDateTime,
    :customFields,
    :customFieldsUri,
    :declinedDateTime,
    :deletedDateTime,
    :deliveredDateTime,
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
    :eventNotification,
    :expireAfter,
    :expireDateTime,
    :expireEnabled,
    :externalEnvelopeId,
    :folders,
    :hasComments,
    :hasFormDataChanged,
    :hasWavFile,
    :holder,
    :initialSentDateTime,
    :is21CFRPart11,
    :isDynamicEnvelope,
    :isSignatureProviderEnvelope,
    :lastModifiedDateTime,
    :location,
    :lockInformation,
    :messageLock,
    :notification,
    :notificationUri,
    :password,
    :powerForm,
    :purgeCompletedDate,
    :purgeRequestDate,
    :purgeState,
    :recipients,
    :recipientsLock,
    :recipientsUri,
    :recipientViewRequest,
    :sender,
    :sentDateTime,
    :signerCanSignOnMobile,
    :signingLocation,
    :status,
    :statusChangedDateTime,
    :statusDateTime,
    :templateId,
    :templateRoles,
    :templatesUri,
    :transactionId,
    :useDisclosure,
    :voidedDateTime,
    :voidedReason,
    :workflow
  ]

  @type t :: %__MODULE__{
          :accessControlListBase64 => String.t() | nil,
          :accessibility => String.t() | nil,
          :allowComments => String.t() | nil,
          :allowMarkup => String.t() | nil,
          :allowReassign => String.t() | nil,
          :allowRecipientRecursion => String.t() | nil,
          :allowViewHistory => String.t() | nil,
          :anySigner => String.t() | nil,
          :asynchronous => String.t() | nil,
          :attachments => [DocuSign.Model.Attachment.t()] | nil,
          :attachmentsUri => String.t() | nil,
          :authoritativeCopy => String.t() | nil,
          :authoritativeCopyDefault => String.t() | nil,
          :autoNavigation => String.t() | nil,
          :brandId => String.t() | nil,
          :brandLock => String.t() | nil,
          :certificateUri => String.t() | nil,
          :completedDateTime => String.t() | nil,
          :compositeTemplates => [DocuSign.Model.CompositeTemplate.t()] | nil,
          :copyRecipientData => String.t() | nil,
          :createdDateTime => String.t() | nil,
          :customFields => DocuSign.Model.AccountCustomFields.t() | nil,
          :customFieldsUri => String.t() | nil,
          :declinedDateTime => String.t() | nil,
          :deletedDateTime => String.t() | nil,
          :deliveredDateTime => String.t() | nil,
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
          :eventNotification => DocuSign.Model.EventNotification.t() | nil,
          :expireAfter => String.t() | nil,
          :expireDateTime => String.t() | nil,
          :expireEnabled => String.t() | nil,
          :externalEnvelopeId => String.t() | nil,
          :folders => [DocuSign.Model.Folder.t()] | nil,
          :hasComments => String.t() | nil,
          :hasFormDataChanged => String.t() | nil,
          :hasWavFile => String.t() | nil,
          :holder => String.t() | nil,
          :initialSentDateTime => String.t() | nil,
          :is21CFRPart11 => String.t() | nil,
          :isDynamicEnvelope => String.t() | nil,
          :isSignatureProviderEnvelope => String.t() | nil,
          :lastModifiedDateTime => String.t() | nil,
          :location => String.t() | nil,
          :lockInformation => DocuSign.Model.EnvelopeLocks.t() | nil,
          :messageLock => String.t() | nil,
          :notification => DocuSign.Model.Notification.t() | nil,
          :notificationUri => String.t() | nil,
          :password => String.t() | nil,
          :powerForm => DocuSign.Model.PowerForm.t() | nil,
          :purgeCompletedDate => String.t() | nil,
          :purgeRequestDate => String.t() | nil,
          :purgeState => String.t() | nil,
          :recipients => DocuSign.Model.EnvelopeRecipients.t() | nil,
          :recipientsLock => String.t() | nil,
          :recipientsUri => String.t() | nil,
          :recipientViewRequest => DocuSign.Model.RecipientViewRequest.t() | nil,
          :sender => DocuSign.Model.UserInfo.t() | nil,
          :sentDateTime => String.t() | nil,
          :signerCanSignOnMobile => String.t() | nil,
          :signingLocation => String.t() | nil,
          :status => String.t() | nil,
          :statusChangedDateTime => String.t() | nil,
          :statusDateTime => String.t() | nil,
          :templateId => String.t() | nil,
          :templateRoles => [DocuSign.Model.TemplateRole.t()] | nil,
          :templatesUri => String.t() | nil,
          :transactionId => String.t() | nil,
          :useDisclosure => String.t() | nil,
          :voidedDateTime => String.t() | nil,
          :voidedReason => String.t() | nil,
          :workflow => DocuSign.Model.Workflow.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeDefinition do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:attachments, :list, DocuSign.Model.Attachment, options)
    |> deserialize(:compositeTemplates, :list, DocuSign.Model.CompositeTemplate, options)
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
    |> deserialize(:eventNotification, :struct, DocuSign.Model.EventNotification, options)
    |> deserialize(:folders, :list, DocuSign.Model.Folder, options)
    |> deserialize(:lockInformation, :struct, DocuSign.Model.EnvelopeLocks, options)
    |> deserialize(:notification, :struct, DocuSign.Model.Notification, options)
    |> deserialize(:powerForm, :struct, DocuSign.Model.PowerForm, options)
    |> deserialize(:recipients, :struct, DocuSign.Model.EnvelopeRecipients, options)
    |> deserialize(:recipientViewRequest, :struct, DocuSign.Model.RecipientViewRequest, options)
    |> deserialize(:sender, :struct, DocuSign.Model.UserInfo, options)
    |> deserialize(:templateRoles, :list, DocuSign.Model.TemplateRole, options)
    |> deserialize(:workflow, :struct, DocuSign.Model.Workflow, options)
  end
end
