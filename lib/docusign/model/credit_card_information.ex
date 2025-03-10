# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.CreditCardInformation do
  @moduledoc """
  This object contains information about a credit card that is associated with an account.
  """

  @derive Jason.Encoder
  defstruct [
    :address,
    :cardLastDigits,
    :cardNumber,
    :cardType,
    :cvNumber,
    :expirationMonth,
    :expirationYear,
    :nameOnCard,
    :tokenizedCard
  ]

  @type t :: %__MODULE__{
          :address => DocuSign.Model.AddressInformation.t() | nil,
          :cardLastDigits => String.t() | nil,
          :cardNumber => String.t() | nil,
          :cardType => String.t() | nil,
          :cvNumber => String.t() | nil,
          :expirationMonth => String.t() | nil,
          :expirationYear => String.t() | nil,
          :nameOnCard => String.t() | nil,
          :tokenizedCard => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:address, :struct, DocuSign.Model.AddressInformation)
  end
end
