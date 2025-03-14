# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PaymentGatewayAccount do
  @moduledoc """
  This object contains details about a payment gateway account.
  """

  @derive Jason.Encoder
  defstruct [
    :allowCustomMetadata,
    :config,
    :displayName,
    :isEnabled,
    :isLegacy,
    :lastModified,
    :paymentGateway,
    :paymentGatewayAccountId,
    :paymentGatewayDisplayName,
    :payPalLegacySettings,
    :supportedCurrencies,
    :supportedPaymentMethods,
    :supportedPaymentMethodsWithOptions,
    :zeroDecimalCurrencies
  ]

  @type t :: %__MODULE__{
          :allowCustomMetadata => boolean() | nil,
          :config => DocuSign.Model.PaymentGatewayAccountSetting.t() | nil,
          :displayName => String.t() | nil,
          :isEnabled => String.t() | nil,
          :isLegacy => String.t() | nil,
          :lastModified => String.t() | nil,
          :paymentGateway => String.t() | nil,
          :paymentGatewayAccountId => String.t() | nil,
          :paymentGatewayDisplayName => String.t() | nil,
          :payPalLegacySettings => DocuSign.Model.PayPalLegacySettings.t() | nil,
          :supportedCurrencies => [String.t()] | nil,
          :supportedPaymentMethods => [String.t()] | nil,
          :supportedPaymentMethodsWithOptions =>
            [DocuSign.Model.PaymentMethodWithOptions.t()] | nil,
          :zeroDecimalCurrencies => [String.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:config, :struct, DocuSign.Model.PaymentGatewayAccountSetting)
    |> Deserializer.deserialize(
      :payPalLegacySettings,
      :struct,
      DocuSign.Model.PayPalLegacySettings
    )
    |> Deserializer.deserialize(
      :supportedPaymentMethodsWithOptions,
      :list,
      DocuSign.Model.PaymentMethodWithOptions
    )
  end
end
