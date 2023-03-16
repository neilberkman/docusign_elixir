# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EventNotification do
  @moduledoc """
  Use this object to configure a [DocuSign Connect webhook](/platform/webhooks/connect/).
  """

  @derive [Poison.Encoder]
  defstruct [
    :deliveryMode,
    :envelopeEvents,
    :eventData,
    :events,
    :includeCertificateOfCompletion,
    :includeCertificateWithSoap,
    :includeDocumentFields,
    :includeDocuments,
    :includeEnvelopeVoidReason,
    :includeHMAC,
    :includeOAuth,
    :includeSenderAccountAsCustomField,
    :includeTimeZone,
    :integratorManaged,
    :loggingEnabled,
    :recipientEvents,
    :requireAcknowledgment,
    :signMessageWithX509Cert,
    :soapNameSpace,
    :url,
    :useSoapInterface
  ]

  @type t :: %__MODULE__{
          :deliveryMode => String.t() | nil,
          :envelopeEvents => [DocuSign.Model.EnvelopeEvent.t()] | nil,
          :eventData => DocuSign.Model.ConnectEventData.t() | nil,
          :events => [String.t()] | nil,
          :includeCertificateOfCompletion => String.t() | nil,
          :includeCertificateWithSoap => String.t() | nil,
          :includeDocumentFields => String.t() | nil,
          :includeDocuments => String.t() | nil,
          :includeEnvelopeVoidReason => String.t() | nil,
          :includeHMAC => String.t() | nil,
          :includeOAuth => String.t() | nil,
          :includeSenderAccountAsCustomField => String.t() | nil,
          :includeTimeZone => String.t() | nil,
          :integratorManaged => String.t() | nil,
          :loggingEnabled => String.t() | nil,
          :recipientEvents => [DocuSign.Model.RecipientEvent.t()] | nil,
          :requireAcknowledgment => String.t() | nil,
          :signMessageWithX509Cert => String.t() | nil,
          :soapNameSpace => String.t() | nil,
          :url => String.t() | nil,
          :useSoapInterface => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EventNotification do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:envelopeEvents, :list, DocuSign.Model.EnvelopeEvent, options)
    |> deserialize(:eventData, :struct, DocuSign.Model.ConnectEventData, options)
    |> deserialize(:recipientEvents, :list, DocuSign.Model.RecipientEvent, options)
  end
end
