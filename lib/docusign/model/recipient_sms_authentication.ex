# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientSmsAuthentication do
  @moduledoc """
  Contains the element senderProvidedNumbers which is an Array  of phone numbers the recipient can use for SMS text authentication.
  """

  @derive [Poison.Encoder]
  defstruct [
    :senderProvidedNumbers,
    :senderProvidedNumbersMetadata
  ]

  @type t :: %__MODULE__{
          :senderProvidedNumbers => [String.t()] | nil,
          :senderProvidedNumbersMetadata => DocuSign.Model.PropertyMetadata.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.RecipientSmsAuthentication do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :senderProvidedNumbersMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
  end
end
