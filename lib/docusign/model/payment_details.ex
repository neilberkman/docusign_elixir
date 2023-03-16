# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PaymentDetails do
  @moduledoc """
  When a formula tab has a `paymentDetails` property, the formula tab is a payment item. See [Requesting Payments Along with Signatures][paymentguide] in the DocuSign Support Center to learn more about payments.  [paymentguide]:     https://support.docusign.com/en/guides/requesting-payments-along-with-signatures
  """

  @derive [Poison.Encoder]
  defstruct [
    :allowedPaymentMethods,
    :chargeId,
    :currencyCode,
    :currencyCodeMetadata,
    :customerId,
    :customMetadata,
    :customMetadataRequired,
    :gatewayAccountId,
    :gatewayAccountIdMetadata,
    :gatewayDisplayName,
    :gatewayName,
    :lineItems,
    :paymentOption,
    :paymentSourceId,
    :signerValues,
    :status,
    :subGatewayName,
    :total
  ]

  @type t :: %__MODULE__{
          :allowedPaymentMethods => [String.t()] | nil,
          :chargeId => String.t() | nil,
          :currencyCode => String.t() | nil,
          :currencyCodeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :customerId => String.t() | nil,
          :customMetadata => String.t() | nil,
          :customMetadataRequired => boolean() | nil,
          :gatewayAccountId => String.t() | nil,
          :gatewayAccountIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :gatewayDisplayName => String.t() | nil,
          :gatewayName => String.t() | nil,
          :lineItems => [DocuSign.Model.PaymentLineItem.t()] | nil,
          :paymentOption => String.t() | nil,
          :paymentSourceId => String.t() | nil,
          :signerValues => DocuSign.Model.PaymentSignerValues.t() | nil,
          :status => String.t() | nil,
          :subGatewayName => String.t() | nil,
          :total => DocuSign.Model.Money.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PaymentDetails do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:currencyCodeMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:gatewayAccountIdMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:lineItems, :list, DocuSign.Model.PaymentLineItem, options)
    |> deserialize(:signerValues, :struct, DocuSign.Model.PaymentSignerValues, options)
    |> deserialize(:total, :struct, DocuSign.Model.Money, options)
  end
end
