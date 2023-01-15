# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeCustomMetadata do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :envelopeCustomMetadataDetails
  ]

  @type t :: %__MODULE__{
          :envelopeCustomMetadataDetails => [DocuSign.Model.NameValue.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeCustomMetadata do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:envelopeCustomMetadataDetails, :list, DocuSign.Model.NameValue, options)
  end
end
