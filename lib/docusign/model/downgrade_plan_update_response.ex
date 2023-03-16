# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DowngradePlanUpdateResponse do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :accountPaymentMethod,
    :discountApplied,
    :downgradeEffectiveDate,
    :downgradePaymentCycle,
    :downgradePlanId,
    :downgradePlanName,
    :downgradeRequestStatus,
    :message,
    :productId,
    :promoCode,
    :saleDiscount,
    :saleDiscountPeriods,
    :saleDiscountType
  ]

  @type t :: %__MODULE__{
          :accountPaymentMethod => String.t() | nil,
          :discountApplied => String.t() | nil,
          :downgradeEffectiveDate => String.t() | nil,
          :downgradePaymentCycle => String.t() | nil,
          :downgradePlanId => String.t() | nil,
          :downgradePlanName => String.t() | nil,
          :downgradeRequestStatus => String.t() | nil,
          :message => String.t() | nil,
          :productId => String.t() | nil,
          :promoCode => String.t() | nil,
          :saleDiscount => String.t() | nil,
          :saleDiscountPeriods => String.t() | nil,
          :saleDiscountType => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.DowngradePlanUpdateResponse do
  def decode(value, _options) do
    value
  end
end
