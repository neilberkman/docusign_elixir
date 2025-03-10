# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientSmsAuthentication do
  @moduledoc """
  Contains the element senderProvidedNumbers which is an Array  of phone numbers the recipient can use for SMS text authentication.
  """

  @derive Jason.Encoder
  defstruct [
    :senderProvidedNumbers,
    :senderProvidedNumbersMetadata
  ]

  @type t :: %__MODULE__{
          :senderProvidedNumbers => [String.t()] | nil,
          :senderProvidedNumbersMetadata => DocuSign.Model.PropertyMetadata.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :senderProvidedNumbersMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
  end
end
