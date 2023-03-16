# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.SenderEmailNotifications do
  @moduledoc """
  Contains the settings for the email notifications that senders receive about the envelopes that they send.
  """

  @derive [Poison.Encoder]
  defstruct [
    :changedSigner,
    :clickwrapResponsesLimitNotificationEmail,
    :commentsOnlyPrivateAndMention,
    :commentsReceiveAll,
    :deliveryFailed,
    :envelopeComplete,
    :offlineSigningFailed,
    :powerformResponsesLimitNotificationEmail,
    :purgeDocuments,
    :recipientViewed,
    :senderEnvelopeDeclined,
    :withdrawnConsent
  ]

  @type t :: %__MODULE__{
          :changedSigner => String.t() | nil,
          :clickwrapResponsesLimitNotificationEmail => String.t() | nil,
          :commentsOnlyPrivateAndMention => String.t() | nil,
          :commentsReceiveAll => String.t() | nil,
          :deliveryFailed => String.t() | nil,
          :envelopeComplete => String.t() | nil,
          :offlineSigningFailed => String.t() | nil,
          :powerformResponsesLimitNotificationEmail => String.t() | nil,
          :purgeDocuments => String.t() | nil,
          :recipientViewed => String.t() | nil,
          :senderEnvelopeDeclined => String.t() | nil,
          :withdrawnConsent => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.SenderEmailNotifications do
  def decode(value, _options) do
    value
  end
end
