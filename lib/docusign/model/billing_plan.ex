# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BillingPlan do
  @moduledoc """
  Contains information about a billing plan.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.AppStoreProduct
  alias DocuSign.Model.CurrencyPlanPrice
  alias DocuSign.Model.FeatureSet
  alias DocuSign.Model.SeatDiscount

  @derive Jason.Encoder
  defstruct [
    :appStoreProducts,
    :currencyPlanPrices,
    :enableSupport,
    :includedSeats,
    :otherDiscountPercent,
    :paymentCycle,
    :paymentMethod,
    :perSeatPrice,
    :planClassification,
    :planFeatureSets,
    :planId,
    :planName,
    :seatDiscounts,
    :supportIncidentFee,
    :supportPlanFee
  ]

  @type t :: %__MODULE__{
          :appStoreProducts => [AppStoreProduct.t()] | nil,
          :currencyPlanPrices => [CurrencyPlanPrice.t()] | nil,
          :enableSupport => String.t() | nil,
          :includedSeats => String.t() | nil,
          :otherDiscountPercent => String.t() | nil,
          :paymentCycle => String.t() | nil,
          :paymentMethod => String.t() | nil,
          :perSeatPrice => String.t() | nil,
          :planClassification => String.t() | nil,
          :planFeatureSets => [FeatureSet.t()] | nil,
          :planId => String.t() | nil,
          :planName => String.t() | nil,
          :seatDiscounts => [SeatDiscount.t()] | nil,
          :supportIncidentFee => String.t() | nil,
          :supportPlanFee => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:appStoreProducts, :list, AppStoreProduct)
    |> Deserializer.deserialize(:currencyPlanPrices, :list, CurrencyPlanPrice)
    |> Deserializer.deserialize(:planFeatureSets, :list, FeatureSet)
    |> Deserializer.deserialize(:seatDiscounts, :list, SeatDiscount)
  end
end
