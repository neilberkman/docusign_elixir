# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DowngradeBillingPlanInformation do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.PlanInformation

  @derive Jason.Encoder
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
          :planInformation => PlanInformation.t() | nil,
          :promoCode => String.t() | nil,
          :saleDiscount => String.t() | nil,
          :saleDiscountPeriods => String.t() | nil,
          :saleDiscountType => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:planInformation, :struct, PlanInformation)
  end
end
