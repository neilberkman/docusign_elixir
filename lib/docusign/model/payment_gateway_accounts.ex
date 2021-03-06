# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.PaymentGatewayAccounts do
  @moduledoc """
  Information about a connected payment gateway account.
  """

  @derive [Poison.Encoder]
  defstruct [
    :displayName,
    :paymentGateway,
    :paymentGatewayAccountId,
    :paymentGatewayDisplayName
  ]

  @type t :: %__MODULE__{
          :displayName => String.t(),
          :paymentGateway => String.t(),
          :paymentGatewayAccountId => String.t(),
          :paymentGatewayDisplayName => String.t()
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PaymentGatewayAccounts do
  def decode(value, _options) do
    value
  end
end
