# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PowerFormFormDataRecipient do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :email,
    :formData,
    :name,
    :recipientId
  ]

  @type t :: %__MODULE__{
          :email => String.t() | nil,
          :formData => [DocuSign.Model.NameValue.t()] | nil,
          :name => String.t() | nil,
          :recipientId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PowerFormFormDataRecipient do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:formData, :list, DocuSign.Model.NameValue, options)
  end
end
