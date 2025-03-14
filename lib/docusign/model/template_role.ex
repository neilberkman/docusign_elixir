# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TemplateRole do
  @moduledoc """
  Information about a specific role.
  """

  @derive Jason.Encoder
  defstruct [
    :accessCode,
    :additionalNotifications,
    :clientUserId,
    :defaultRecipient,
    :deliveryMethod,
    :email,
    :emailNotification,
    :embeddedRecipientStartURL,
    :inPersonSignerName,
    :name,
    :phoneNumber,
    :recipientSignatureProviders,
    :roleName,
    :routingOrder,
    :signingGroupId,
    :tabs
  ]

  @type t :: %__MODULE__{
          :accessCode => String.t() | nil,
          :additionalNotifications => [DocuSign.Model.RecipientAdditionalNotification.t()] | nil,
          :clientUserId => String.t() | nil,
          :defaultRecipient => String.t() | nil,
          :deliveryMethod => String.t() | nil,
          :email => String.t() | nil,
          :emailNotification => DocuSign.Model.RecipientEmailNotification.t() | nil,
          :embeddedRecipientStartURL => String.t() | nil,
          :inPersonSignerName => String.t() | nil,
          :name => String.t() | nil,
          :phoneNumber => DocuSign.Model.RecipientPhoneNumber.t() | nil,
          :recipientSignatureProviders => [DocuSign.Model.RecipientSignatureProvider.t()] | nil,
          :roleName => String.t() | nil,
          :routingOrder => String.t() | nil,
          :signingGroupId => String.t() | nil,
          :tabs => DocuSign.Model.EnvelopeRecipientTabs.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :additionalNotifications,
      :list,
      DocuSign.Model.RecipientAdditionalNotification
    )
    |> Deserializer.deserialize(
      :emailNotification,
      :struct,
      DocuSign.Model.RecipientEmailNotification
    )
    |> Deserializer.deserialize(:phoneNumber, :struct, DocuSign.Model.RecipientPhoneNumber)
    |> Deserializer.deserialize(
      :recipientSignatureProviders,
      :list,
      DocuSign.Model.RecipientSignatureProvider
    )
    |> Deserializer.deserialize(:tabs, :struct, DocuSign.Model.EnvelopeRecipientTabs)
  end
end
