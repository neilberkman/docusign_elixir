# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Money do
  @moduledoc """
  Describes information about the `total` of a payment. 
  """

  @derive [Poison.Encoder]
  defstruct [
    :amountInBaseUnit,
    :currency,
    :displayAmount
  ]

  @type t :: %__MODULE__{
          :amountInBaseUnit => String.t() | nil,
          :currency => String.t() | nil,
          :displayAmount => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.Money do
  def decode(value, _options) do
    value
  end
end
