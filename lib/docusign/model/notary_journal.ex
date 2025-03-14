# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.NotaryJournal do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :createdDate,
    :documentName,
    :jurisdiction,
    :notaryJournalId,
    :notaryJournalMetaData,
    :signerName
  ]

  @type t :: %__MODULE__{
          :createdDate => String.t() | nil,
          :documentName => String.t() | nil,
          :jurisdiction => DocuSign.Model.Jurisdiction.t() | nil,
          :notaryJournalId => String.t() | nil,
          :notaryJournalMetaData => DocuSign.Model.NotaryJournalMetaData.t() | nil,
          :signerName => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:jurisdiction, :struct, DocuSign.Model.Jurisdiction)
    |> Deserializer.deserialize(
      :notaryJournalMetaData,
      :struct,
      DocuSign.Model.NotaryJournalMetaData
    )
  end
end
