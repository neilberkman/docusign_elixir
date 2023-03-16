# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeDocuments do
  @moduledoc """
  Envelope documents
  """

  @derive [Poison.Encoder]
  defstruct [
    :envelopeDocuments,
    :envelopeId
  ]

  @type t :: %__MODULE__{
          :envelopeDocuments => [DocuSign.Model.EnvelopeDocument.t()] | nil,
          :envelopeId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeDocuments do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:envelopeDocuments, :list, DocuSign.Model.EnvelopeDocument, options)
  end
end
