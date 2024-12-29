# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PurchasedEnvelopesInformation do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :amount,
    :appName,
    :currencyCode,
    :platform,
    :productId,
    :quantity,
    :receiptData,
    :storeName,
    :transactionId
  ]

  @type t :: %__MODULE__{
          :amount => String.t() | nil,
          :appName => String.t() | nil,
          :currencyCode => String.t() | nil,
          :platform => String.t() | nil,
          :productId => String.t() | nil,
          :quantity => String.t() | nil,
          :receiptData => String.t() | nil,
          :storeName => String.t() | nil,
          :transactionId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PurchasedEnvelopesInformation do
  def decode(value, _options) do
    value
  end
end
