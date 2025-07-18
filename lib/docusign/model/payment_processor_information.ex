# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PaymentProcessorInformation do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.AddressInformation

  @derive Jason.Encoder
  defstruct [
    :address,
    :billingAgreementId,
    :email
  ]

  @type t :: %__MODULE__{
          :address => AddressInformation.t() | nil,
          :billingAgreementId => String.t() | nil,
          :email => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:address, :struct, AddressInformation)
  end
end
