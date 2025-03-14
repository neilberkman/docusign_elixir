# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BillingPaymentsResponse do
  @moduledoc """
  Defines a billing payments response object.
  """

  @derive Jason.Encoder
  defstruct [
    :billingPayments,
    :nextUri,
    :previousUri
  ]

  @type t :: %__MODULE__{
          :billingPayments => [DocuSign.Model.BillingPaymentItem.t()] | nil,
          :nextUri => String.t() | nil,
          :previousUri => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:billingPayments, :list, DocuSign.Model.BillingPaymentItem)
  end
end
