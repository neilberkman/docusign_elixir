# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DowngradeBillingPlanInformation do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :downgradeEventType,
    :planInformation,
    :promoCode,
    :saleDiscount,
    :saleDiscountPeriods,
    :saleDiscountType
  ]

  @type t :: %__MODULE__{
          :downgradeEventType => String.t() | nil,
          :planInformation => DocuSign.Model.PlanInformation.t() | nil,
          :promoCode => String.t() | nil,
          :saleDiscount => String.t() | nil,
          :saleDiscountPeriods => String.t() | nil,
          :saleDiscountType => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.DowngradeBillingPlanInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:planInformation, :struct, DocuSign.Model.PlanInformation, options)
  end
end
