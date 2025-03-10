# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AppStoreReceipt do
  @moduledoc """
  Contains information about an APP store receipt.
  """

  @derive Jason.Encoder
  defstruct [
    :downgradeProductId,
    :isDowngradeCancellation,
    :productId,
    :receiptData
  ]

  @type t :: %__MODULE__{
          :downgradeProductId => String.t() | nil,
          :isDowngradeCancellation => String.t() | nil,
          :productId => String.t() | nil,
          :receiptData => String.t() | nil
        }

  def decode(value) do
    value
  end
end
