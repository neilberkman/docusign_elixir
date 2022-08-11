# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.BulkSendingCopy do
  @moduledoc """
  This object contains the details to use for a specific copy, or instance, of the envelope. When you send an envelope by using a bulk send list, you can customize these properties for each instance.
  """

  @derive [Poison.Encoder]
  defstruct [
    :customFields,
    :emailBlurb,
    :emailSubject,
    :recipients
  ]

  @type t :: %__MODULE__{
    :customFields => [DocuSign.Model.BulkSendingCopyCustomField.t] | nil,
    :emailBlurb => String.t | nil,
    :emailSubject => String.t | nil,
    :recipients => [DocuSign.Model.BulkSendingCopyRecipient.t] | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.BulkSendingCopy do
  import DocuSign.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:customFields, :list, DocuSign.Model.BulkSendingCopyCustomField, options)
    |> deserialize(:recipients, :list, DocuSign.Model.BulkSendingCopyRecipient, options)
  end
end
