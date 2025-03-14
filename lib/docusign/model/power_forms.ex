# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PowerForms do
  @moduledoc """
  The PowerForms resource enables you to create fillable forms that you can email or make available for self service on the web.
  """

  @derive Jason.Encoder
  defstruct [
    :createdBy,
    :createdDateTime,
    :emailBody,
    :emailSubject,
    :envelopes,
    :errorDetails,
    :instructions,
    :isActive,
    :lastUsed,
    :limitUseInterval,
    :limitUseIntervalEnabled,
    :limitUseIntervalUnits,
    :maxUseEnabled,
    :name,
    :powerFormId,
    :powerFormUrl,
    :recipients,
    :senderName,
    :senderUserId,
    :signingMode,
    :templateId,
    :templateName,
    :timesUsed,
    :uri,
    :usesRemaining
  ]

  @type t :: %__MODULE__{
          :createdBy => String.t() | nil,
          :createdDateTime => String.t() | nil,
          :emailBody => String.t() | nil,
          :emailSubject => String.t() | nil,
          :envelopes => [DocuSign.Model.Envelope.t()] | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :instructions => String.t() | nil,
          :isActive => String.t() | nil,
          :lastUsed => String.t() | nil,
          :limitUseInterval => String.t() | nil,
          :limitUseIntervalEnabled => String.t() | nil,
          :limitUseIntervalUnits => String.t() | nil,
          :maxUseEnabled => String.t() | nil,
          :name => String.t() | nil,
          :powerFormId => String.t() | nil,
          :powerFormUrl => String.t() | nil,
          :recipients => [DocuSign.Model.PowerFormRecipient.t()] | nil,
          :senderName => String.t() | nil,
          :senderUserId => String.t() | nil,
          :signingMode => String.t() | nil,
          :templateId => String.t() | nil,
          :templateName => String.t() | nil,
          :timesUsed => String.t() | nil,
          :uri => String.t() | nil,
          :usesRemaining => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:envelopes, :list, DocuSign.Model.Envelope)
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:recipients, :list, DocuSign.Model.PowerFormRecipient)
  end
end
