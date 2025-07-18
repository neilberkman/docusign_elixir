# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BillingPaymentsResponse do
  @moduledoc """
  Defines a billing payments response object.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.BillingPaymentItem

  @derive Jason.Encoder
  defstruct [
    :billingPayments,
    :nextUri,
    :previousUri
  ]

  @type t :: %__MODULE__{
          :billingPayments => [BillingPaymentItem.t()] | nil,
          :nextUri => String.t() | nil,
          :previousUri => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:billingPayments, :list, BillingPaymentItem)
  end
end
