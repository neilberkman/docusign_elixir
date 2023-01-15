# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BillingInvoiceItem do
  @moduledoc """
  Contains information about an item on a billing invoice.
  """

  @derive [Poison.Encoder]
  defstruct [
    :chargeAmount,
    :chargeName,
    :invoiceItemId,
    :quantity,
    :taxAmount,
    :taxExemptAmount,
    :unitPrice
  ]

  @type t :: %__MODULE__{
          :chargeAmount => String.t() | nil,
          :chargeName => String.t() | nil,
          :invoiceItemId => String.t() | nil,
          :quantity => String.t() | nil,
          :taxAmount => String.t() | nil,
          :taxExemptAmount => String.t() | nil,
          :unitPrice => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BillingInvoiceItem do
  def decode(value, _options) do
    value
  end
end
