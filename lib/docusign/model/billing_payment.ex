# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BillingPayment do
  @moduledoc """
  Contains information on a billing plan.
  """

  @derive Jason.Encoder
  defstruct [
    :amount,
    :invoiceId,
    :paymentId
  ]

  @type t :: %__MODULE__{
          :amount => String.t() | nil,
          :invoiceId => String.t() | nil,
          :paymentId => String.t() | nil
        }

  def decode(value) do
    value
  end
end
