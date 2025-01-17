# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.NotaryJournalMetaData do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :comment,
    :credibleWitnesses,
    :signatureImage,
    :signerIdType
  ]

  @type t :: %__MODULE__{
          :comment => String.t() | nil,
          :credibleWitnesses => [DocuSign.Model.NotaryJournalCredibleWitness.t()] | nil,
          :signatureImage => String.t() | nil,
          :signerIdType => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.NotaryJournalMetaData do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :credibleWitnesses,
      :list,
      DocuSign.Model.NotaryJournalCredibleWitness,
      options
    )
  end
end
