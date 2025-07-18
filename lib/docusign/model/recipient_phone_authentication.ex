# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientPhoneAuthentication do
  @moduledoc """
  A complex type that contains the elements:  * `recipMayProvideNumber`: A Boolean value that specifies whether the recipient can use the phone number of their choice. * `senderProvidedNumbers`: A list of phone numbers that the recipient can use. * `recordVoicePrint`: Reserved for Docusign. * `validateRecipProvidedNumber`: Reserved for Docusign.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.PropertyMetadata

  @derive Jason.Encoder
  defstruct [
    :recipMayProvideNumber,
    :recipMayProvideNumberMetadata,
    :recordVoicePrint,
    :recordVoicePrintMetadata,
    :senderProvidedNumbers,
    :senderProvidedNumbersMetadata,
    :validateRecipProvidedNumber,
    :validateRecipProvidedNumberMetadata
  ]

  @type t :: %__MODULE__{
          :recipMayProvideNumber => String.t() | nil,
          :recipMayProvideNumberMetadata => PropertyMetadata.t() | nil,
          :recordVoicePrint => String.t() | nil,
          :recordVoicePrintMetadata => PropertyMetadata.t() | nil,
          :senderProvidedNumbers => [String.t()] | nil,
          :senderProvidedNumbersMetadata => PropertyMetadata.t() | nil,
          :validateRecipProvidedNumber => String.t() | nil,
          :validateRecipProvidedNumberMetadata => PropertyMetadata.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :recipMayProvideNumberMetadata,
      :struct,
      PropertyMetadata
    )
    |> Deserializer.deserialize(
      :recordVoicePrintMetadata,
      :struct,
      PropertyMetadata
    )
    |> Deserializer.deserialize(
      :senderProvidedNumbersMetadata,
      :struct,
      PropertyMetadata
    )
    |> Deserializer.deserialize(
      :validateRecipProvidedNumberMetadata,
      :struct,
      PropertyMetadata
    )
  end
end
