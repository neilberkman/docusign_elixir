# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BillingPlanInformation do
  @moduledoc """
  This object contains details about a billing plan.
  """

  @derive Jason.Encoder
  defstruct [
    :appStoreReceipt,
    :billingAddress,
    :creditCardInformation,
    :directDebitProcessorInformation,
    :downgradeReason,
    :enablePreAuth,
    :enableSupport,
    :includedSeats,
    :incrementalSeats,
    :paymentMethod,
    :paymentProcessor,
    :paymentProcessorInformation,
    :planInformation,
    :processPayment,
    :referralInformation,
    :renewalStatus,
    :saleDiscountAmount,
    :saleDiscountFixedAmount,
    :saleDiscountPercent,
    :saleDiscountPeriods,
    :saleDiscountSeatPriceOverride,
    :taxExemptId
  ]

  @type t :: %__MODULE__{
          :appStoreReceipt => DocuSign.Model.AppStoreReceipt.t() | nil,
          :billingAddress => DocuSign.Model.AccountAddress.t() | nil,
          :creditCardInformation => DocuSign.Model.CreditCardInformation.t() | nil,
          :directDebitProcessorInformation =>
            DocuSign.Model.DirectDebitProcessorInformation.t() | nil,
          :downgradeReason => String.t() | nil,
          :enablePreAuth => String.t() | nil,
          :enableSupport => String.t() | nil,
          :includedSeats => String.t() | nil,
          :incrementalSeats => String.t() | nil,
          :paymentMethod => String.t() | nil,
          :paymentProcessor => String.t() | nil,
          :paymentProcessorInformation => DocuSign.Model.PaymentProcessorInformation.t() | nil,
          :planInformation => DocuSign.Model.PlanInformation.t() | nil,
          :processPayment => String.t() | nil,
          :referralInformation => DocuSign.Model.ReferralInformation.t() | nil,
          :renewalStatus => String.t() | nil,
          :saleDiscountAmount => String.t() | nil,
          :saleDiscountFixedAmount => String.t() | nil,
          :saleDiscountPercent => String.t() | nil,
          :saleDiscountPeriods => String.t() | nil,
          :saleDiscountSeatPriceOverride => String.t() | nil,
          :taxExemptId => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:appStoreReceipt, :struct, DocuSign.Model.AppStoreReceipt)
    |> Deserializer.deserialize(:billingAddress, :struct, DocuSign.Model.AccountAddress)
    |> Deserializer.deserialize(
      :creditCardInformation,
      :struct,
      DocuSign.Model.CreditCardInformation
    )
    |> Deserializer.deserialize(
      :directDebitProcessorInformation,
      :struct,
      DocuSign.Model.DirectDebitProcessorInformation
    )
    |> Deserializer.deserialize(
      :paymentProcessorInformation,
      :struct,
      DocuSign.Model.PaymentProcessorInformation
    )
    |> Deserializer.deserialize(:planInformation, :struct, DocuSign.Model.PlanInformation)
    |> Deserializer.deserialize(:referralInformation, :struct, DocuSign.Model.ReferralInformation)
  end
end
