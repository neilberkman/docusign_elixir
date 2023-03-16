# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BillingEntityInformationResponse do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :billingProfile,
    :entityName,
    :externalEntityId,
    :isExternallyBilled
  ]

  @type t :: %__MODULE__{
          :billingProfile => String.t() | nil,
          :entityName => String.t() | nil,
          :externalEntityId => String.t() | nil,
          :isExternallyBilled => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BillingEntityInformationResponse do
  def decode(value, _options) do
    value
  end
end
