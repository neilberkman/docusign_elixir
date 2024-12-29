# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeTransactionStatus do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :envelopeId,
    :errorDetails,
    :status,
    :transactionId
  ]

  @type t :: %__MODULE__{
          :envelopeId => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :status => String.t() | nil,
          :transactionId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeTransactionStatus do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
  end
end
