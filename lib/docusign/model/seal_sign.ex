# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.SealSign do
  @moduledoc """
  Specifies one or more electronic seals to apply on documents. An electronic seal recipient is a legal entity rather than an actual person. Electronic Seals can be used by organizations and governments to show evidence of origin and integrity of documents. Even though electronic seals can be represented by a tab in a document, they do not require user interaction and apply automatically in the order specified by the sender. The sender is therefore the person authorizing usage of the electronic seal in the flow.  Example:  ```json \"recipients\": {       \"seals\": [         {           \"recipientId\": \"1\",           \"routingOrder\" : 1,           \"recipientSignatureProviders\": [             {               \"sealName\": \"52e9d968-xxxx-xxxx-xxxx-4682bc45c106\"             }         ]       }     ]   },     .     .     . ``` For more information about Electronic Seals, see [Apply Electronic Seals to Your Documents](https://support.docusign.com/s/document-item?bundleId=xcm1643837555908&topicId=isl1578456577247.html). 
  """

  @derive Jason.Encoder
  defstruct [
    :accessCode,
    :accessCodeMetadata,
    :addAccessCodeToEmail,
    :allowSystemOverrideForLockedRecipient,
    :autoRespondedReason,
    :bulkSendV2Recipient,
    :clientUserId,
    :completedCount,
    :customFields,
    :declinedDateTime,
    :declinedReason,
    :deliveredDateTime,
    :deliveryMethod,
    :deliveryMethodMetadata,
    :designatorId,
    :designatorIdGuid,
    :documentTemplateId,
    :documentVisibility,
    :emailNotification,
    :embeddedRecipientStartURL,
    :errorDetails,
    :faxNumber,
    :faxNumberMetadata,
    :idCheckConfigurationName,
    :idCheckConfigurationNameMetadata,
    :idCheckInformationInput,
    :identityVerification,
    :inheritEmailNotificationConfiguration,
    :lockedRecipientPhoneAuthEditable,
    :lockedRecipientSmsEditable,
    :name,
    :note,
    :noteMetadata,
    :phoneAuthentication,
    :recipientAttachments,
    :recipientAuthenticationStatus,
    :recipientFeatureMetadata,
    :recipientId,
    :recipientIdGuid,
    :recipientSignatureProviders,
    :recipientType,
    :recipientTypeMetadata,
    :requireIdLookup,
    :requireIdLookupMetadata,
    :roleName,
    :routingOrder,
    :routingOrderMetadata,
    :sentDateTime,
    :signedDateTime,
    :smsAuthentication,
    :socialAuthentications,
    :status,
    :statusCode,
    :suppressEmails,
    :tabs,
    :templateLocked,
    :templateRequired,
    :totalTabCount,
    :userId,
    :webFormRecipientViewId
  ]

  @type t :: %__MODULE__{
          :accessCode => String.t() | nil,
          :accessCodeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :addAccessCodeToEmail => String.t() | nil,
          :allowSystemOverrideForLockedRecipient => String.t() | nil,
          :autoRespondedReason => String.t() | nil,
          :bulkSendV2Recipient => String.t() | nil,
          :clientUserId => String.t() | nil,
          :completedCount => String.t() | nil,
          :customFields => [String.t()] | nil,
          :declinedDateTime => String.t() | nil,
          :declinedReason => String.t() | nil,
          :deliveredDateTime => String.t() | nil,
          :deliveryMethod => String.t() | nil,
          :deliveryMethodMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :designatorId => String.t() | nil,
          :designatorIdGuid => String.t() | nil,
          :documentTemplateId => String.t() | nil,
          :documentVisibility => [DocuSign.Model.DocumentVisibility.t()] | nil,
          :emailNotification => DocuSign.Model.RecipientEmailNotification.t() | nil,
          :embeddedRecipientStartURL => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :faxNumber => String.t() | nil,
          :faxNumberMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :idCheckConfigurationName => String.t() | nil,
          :idCheckConfigurationNameMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :idCheckInformationInput => DocuSign.Model.IdCheckInformationInput.t() | nil,
          :identityVerification => DocuSign.Model.RecipientIdentityVerification.t() | nil,
          :inheritEmailNotificationConfiguration => String.t() | nil,
          :lockedRecipientPhoneAuthEditable => String.t() | nil,
          :lockedRecipientSmsEditable => String.t() | nil,
          :name => String.t() | nil,
          :note => String.t() | nil,
          :noteMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :phoneAuthentication => DocuSign.Model.RecipientPhoneAuthentication.t() | nil,
          :recipientAttachments => [DocuSign.Model.RecipientAttachment.t()] | nil,
          :recipientAuthenticationStatus => DocuSign.Model.AuthenticationStatus.t() | nil,
          :recipientFeatureMetadata => [DocuSign.Model.FeatureAvailableMetadata.t()] | nil,
          :recipientId => String.t() | nil,
          :recipientIdGuid => String.t() | nil,
          :recipientSignatureProviders => [DocuSign.Model.RecipientSignatureProvider.t()] | nil,
          :recipientType => String.t() | nil,
          :recipientTypeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :requireIdLookup => String.t() | nil,
          :requireIdLookupMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :roleName => String.t() | nil,
          :routingOrder => String.t() | nil,
          :routingOrderMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :sentDateTime => String.t() | nil,
          :signedDateTime => String.t() | nil,
          :smsAuthentication => DocuSign.Model.RecipientSmsAuthentication.t() | nil,
          :socialAuthentications => [DocuSign.Model.SocialAuthentication.t()] | nil,
          :status => String.t() | nil,
          :statusCode => String.t() | nil,
          :suppressEmails => String.t() | nil,
          :tabs => DocuSign.Model.EnvelopeRecipientTabs.t() | nil,
          :templateLocked => String.t() | nil,
          :templateRequired => String.t() | nil,
          :totalTabCount => String.t() | nil,
          :userId => String.t() | nil,
          :webFormRecipientViewId => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:accessCodeMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:deliveryMethodMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:documentVisibility, :list, DocuSign.Model.DocumentVisibility)
    |> Deserializer.deserialize(
      :emailNotification,
      :struct,
      DocuSign.Model.RecipientEmailNotification
    )
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:faxNumberMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :idCheckConfigurationNameMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(
      :idCheckInformationInput,
      :struct,
      DocuSign.Model.IdCheckInformationInput
    )
    |> Deserializer.deserialize(
      :identityVerification,
      :struct,
      DocuSign.Model.RecipientIdentityVerification
    )
    |> Deserializer.deserialize(:noteMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :phoneAuthentication,
      :struct,
      DocuSign.Model.RecipientPhoneAuthentication
    )
    |> Deserializer.deserialize(:recipientAttachments, :list, DocuSign.Model.RecipientAttachment)
    |> Deserializer.deserialize(
      :recipientAuthenticationStatus,
      :struct,
      DocuSign.Model.AuthenticationStatus
    )
    |> Deserializer.deserialize(
      :recipientFeatureMetadata,
      :list,
      DocuSign.Model.FeatureAvailableMetadata
    )
    |> Deserializer.deserialize(
      :recipientSignatureProviders,
      :list,
      DocuSign.Model.RecipientSignatureProvider
    )
    |> Deserializer.deserialize(:recipientTypeMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :requireIdLookupMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:routingOrderMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :smsAuthentication,
      :struct,
      DocuSign.Model.RecipientSmsAuthentication
    )
    |> Deserializer.deserialize(
      :socialAuthentications,
      :list,
      DocuSign.Model.SocialAuthentication
    )
    |> Deserializer.deserialize(:tabs, :struct, DocuSign.Model.EnvelopeRecipientTabs)
  end
end
