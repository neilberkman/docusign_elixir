# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeFormData do
  @moduledoc """
  This object contains the data that recipients have entered into the form fields associated with an envelope.
  """

  @derive [Poison.Encoder]
  defstruct [
    :emailSubject,
    :envelopeId,
    :formData,
    :prefillFormData,
    :recipientFormData,
    :sentDateTime,
    :status
  ]

  @type t :: %__MODULE__{
          :emailSubject => String.t() | nil,
          :envelopeId => String.t() | nil,
          :formData => [DocuSign.Model.FormDataItem.t()] | nil,
          :prefillFormData => DocuSign.Model.PrefillFormData.t() | nil,
          :recipientFormData => [DocuSign.Model.RecipientFormData.t()] | nil,
          :sentDateTime => String.t() | nil,
          :status => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeFormData do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:formData, :list, DocuSign.Model.FormDataItem, options)
    |> deserialize(:prefillFormData, :struct, DocuSign.Model.PrefillFormData, options)
    |> deserialize(:recipientFormData, :list, DocuSign.Model.RecipientFormData, options)
  end
end
