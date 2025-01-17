# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BillingInvoicesSummary do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :accountBalance,
    :billingInvoices,
    :currencyCode,
    :pastDueBalance,
    :paymentAllowed
  ]

  @type t :: %__MODULE__{
          :accountBalance => String.t() | nil,
          :billingInvoices => [DocuSign.Model.BillingInvoice.t()] | nil,
          :currencyCode => String.t() | nil,
          :pastDueBalance => String.t() | nil,
          :paymentAllowed => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BillingInvoicesSummary do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:billingInvoices, :list, DocuSign.Model.BillingInvoice, options)
  end
end
