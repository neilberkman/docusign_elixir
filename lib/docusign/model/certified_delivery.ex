# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.CertifiedDelivery do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :accessCode,
    :addAccessCodeToEmail,
    :agentCanEditEmail,
    :agentCanEditName,
    :clientUserId,
    :customFields,
    :declinedDateTime,
    :declinedReason,
    :deliveredDateTime,
    :deliveryMethod,
    :documentVisibility,
    :email,
    :emailNotification,
    :emailRecipientPostSigningURL,
    :embeddedRecipientStartURL,
    :errorDetails,
    :excludedDocuments,
    :faxNumber,
    :idCheckConfigurationName,
    :idCheckInformationInput,
    :inheritEmailNotificationConfiguration,
    :name,
    :note,
    :phoneAuthentication,
    :recipientAttachments,
    :recipientAuthenticationStatus,
    :recipientId,
    :recipientIdGuid,
    :requireIdLookup,
    :roleName,
    :routingOrder,
    :samlAuthentication,
    :sentDateTime,
    :signedDateTime,
    :signingGroupId,
    :signingGroupName,
    :signingGroupUsers,
    :smsAuthentication,
    :socialAuthentications,
    :status,
    :templateLocked,
    :templateRequired,
    :totalTabCount,
    :userId
  ]

  @type t :: %__MODULE__{
          :accessCode => String.t(),
          :addAccessCodeToEmail => String.t(),
          :agentCanEditEmail => String.t(),
          :agentCanEditName => String.t(),
          :clientUserId => String.t(),
          :customFields => [String.t()],
          :declinedDateTime => String.t(),
          :declinedReason => String.t(),
          :deliveredDateTime => String.t(),
          :deliveryMethod => String.t(),
          :documentVisibility => [DocumentVisibility],
          :email => String.t(),
          :emailNotification => RecipientEmailNotification,
          :emailRecipientPostSigningURL => String.t(),
          :embeddedRecipientStartURL => String.t(),
          :errorDetails => ErrorDetails,
          :excludedDocuments => [String.t()],
          :faxNumber => String.t(),
          :idCheckConfigurationName => String.t(),
          :idCheckInformationInput => IdCheckInformationInput,
          :inheritEmailNotificationConfiguration => String.t(),
          :name => String.t(),
          :note => String.t(),
          :phoneAuthentication => RecipientPhoneAuthentication,
          :recipientAttachments => [RecipientAttachment],
          :recipientAuthenticationStatus => AuthenticationStatus,
          :recipientId => String.t(),
          :recipientIdGuid => String.t(),
          :requireIdLookup => String.t(),
          :roleName => String.t(),
          :routingOrder => String.t(),
          :samlAuthentication => RecipientSamlAuthentication,
          :sentDateTime => String.t(),
          :signedDateTime => String.t(),
          :signingGroupId => String.t(),
          :signingGroupName => String.t(),
          :signingGroupUsers => [UserInfo],
          :smsAuthentication => RecipientSmsAuthentication,
          :socialAuthentications => [SocialAuthentication],
          :status => String.t(),
          :templateLocked => String.t(),
          :templateRequired => String.t(),
          :totalTabCount => String.t(),
          :userId => String.t()
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.CertifiedDelivery do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:documentVisibility, :list, DocuSign.Model.DocumentVisibility, options)
    |> deserialize(
      :emailNotification,
      :struct,
      DocuSign.Model.RecipientEmailNotification,
      options
    )
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
    |> deserialize(
      :idCheckInformationInput,
      :struct,
      DocuSign.Model.IdCheckInformationInput,
      options
    )
    |> deserialize(
      :phoneAuthentication,
      :struct,
      DocuSign.Model.RecipientPhoneAuthentication,
      options
    )
    |> deserialize(:recipientAttachments, :list, DocuSign.Model.RecipientAttachment, options)
    |> deserialize(
      :recipientAuthenticationStatus,
      :struct,
      DocuSign.Model.AuthenticationStatus,
      options
    )
    |> deserialize(
      :samlAuthentication,
      :struct,
      DocuSign.Model.RecipientSamlAuthentication,
      options
    )
    |> deserialize(:signingGroupUsers, :list, DocuSign.Model.UserInfo, options)
    |> deserialize(
      :smsAuthentication,
      :struct,
      DocuSign.Model.RecipientSmsAuthentication,
      options
    )
    |> deserialize(:socialAuthentications, :list, DocuSign.Model.SocialAuthentication, options)
  end
end
