# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkSendingCopyRecipient do
  @moduledoc """
  This object contains details about a bulk send recipient.
  """

  @derive Jason.Encoder
  defstruct [
    :accessCode,
    :clientUserId,
    :customFields,
    :deliveryMethod,
    :email,
    :emailNotification,
    :embeddedRecipientStartURL,
    :faxNumber,
    :hostEmail,
    :hostName,
    :idCheckConfigurationName,
    :idCheckInformationInput,
    :identificationMethod,
    :identityVerification,
    :name,
    :note,
    :phoneAuthentication,
    :recipientId,
    :recipientSignatureProviders,
    :roleName,
    :signerName,
    :signingGroupId,
    :smsAuthentication,
    :socialAuthentications,
    :tabs
  ]

  @type t :: %__MODULE__{
          :accessCode => String.t() | nil,
          :clientUserId => String.t() | nil,
          :customFields => [String.t()] | nil,
          :deliveryMethod => String.t() | nil,
          :email => String.t() | nil,
          :emailNotification => DocuSign.Model.RecipientEmailNotification.t() | nil,
          :embeddedRecipientStartURL => String.t() | nil,
          :faxNumber => String.t() | nil,
          :hostEmail => String.t() | nil,
          :hostName => String.t() | nil,
          :idCheckConfigurationName => String.t() | nil,
          :idCheckInformationInput => DocuSign.Model.IdCheckInformationInput.t() | nil,
          :identificationMethod => String.t() | nil,
          :identityVerification => DocuSign.Model.RecipientIdentityVerification.t() | nil,
          :name => String.t() | nil,
          :note => String.t() | nil,
          :phoneAuthentication => DocuSign.Model.RecipientPhoneAuthentication.t() | nil,
          :recipientId => String.t() | nil,
          :recipientSignatureProviders => [DocuSign.Model.RecipientSignatureProvider.t()] | nil,
          :roleName => String.t() | nil,
          :signerName => String.t() | nil,
          :signingGroupId => String.t() | nil,
          :smsAuthentication => DocuSign.Model.RecipientSmsAuthentication.t() | nil,
          :socialAuthentications => [DocuSign.Model.SocialAuthentication.t()] | nil,
          :tabs => [DocuSign.Model.BulkSendingCopyTab.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :emailNotification,
      :struct,
      DocuSign.Model.RecipientEmailNotification
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
    |> Deserializer.deserialize(
      :phoneAuthentication,
      :struct,
      DocuSign.Model.RecipientPhoneAuthentication
    )
    |> Deserializer.deserialize(
      :recipientSignatureProviders,
      :list,
      DocuSign.Model.RecipientSignatureProvider
    )
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
    |> Deserializer.deserialize(:tabs, :list, DocuSign.Model.BulkSendingCopyTab)
  end
end
