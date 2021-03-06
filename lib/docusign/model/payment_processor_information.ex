# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.PaymentProcessorInformation do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :address,
    :billingAgreementId,
    :email
  ]

  @type t :: %__MODULE__{
          :address => AddressInformation,
          :billingAgreementId => String.t(),
          :email => String.t()
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PaymentProcessorInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:address, :struct, DocuSign.Model.AddressInformation, options)
  end
end
