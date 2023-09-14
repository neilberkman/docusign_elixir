# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PaymentGatewayAccount do
  @moduledoc """
  This object contains details about a payment gateway account.
  """

  @derive [Poison.Encoder]
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
end

defimpl Poison.Decoder, for: DocuSign.Model.PaymentGatewayAccount do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:config, :struct, DocuSign.Model.PaymentGatewayAccountSetting, options)
    |> deserialize(:payPalLegacySettings, :struct, DocuSign.Model.PayPalLegacySettings, options)
    |> deserialize(
      :supportedPaymentMethodsWithOptions,
      :list,
      DocuSign.Model.PaymentMethodWithOptions,
      options
    )
  end
end