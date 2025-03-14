# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientAdditionalNotification do
  @moduledoc """
  Describes an additional notification method.
  """

  @derive Jason.Encoder
  defstruct [
    :phoneNumber,
    :secondaryDeliveryMethod,
    :secondaryDeliveryMethodMetadata,
    :secondaryDeliveryStatus
  ]

  @type t :: %__MODULE__{
          :phoneNumber => DocuSign.Model.RecipientPhoneNumber.t() | nil,
          :secondaryDeliveryMethod => String.t() | nil,
          :secondaryDeliveryMethodMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :secondaryDeliveryStatus => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:phoneNumber, :struct, DocuSign.Model.RecipientPhoneNumber)
    |> Deserializer.deserialize(
      :secondaryDeliveryMethodMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
  end
end
