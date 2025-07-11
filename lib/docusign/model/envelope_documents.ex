# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeDocuments do
  @moduledoc """
  Envelope documents
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.EnvelopeDocument

  @derive Jason.Encoder
  defstruct [
    :envelopeDocuments,
    :envelopeId
  ]

  @type t :: %__MODULE__{
          :envelopeDocuments => [EnvelopeDocument.t()] | nil,
          :envelopeId => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:envelopeDocuments, :list, EnvelopeDocument)
  end
end
