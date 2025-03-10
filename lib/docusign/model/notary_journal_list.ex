# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.NotaryJournalList do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :endPosition,
    :nextUri,
    :notaryJournals,
    :previousUri,
    :resultSetSize,
    :startPosition,
    :totalSetSize
  ]

  @type t :: %__MODULE__{
          :endPosition => String.t() | nil,
          :nextUri => String.t() | nil,
          :notaryJournals => [DocuSign.Model.NotaryJournal.t()] | nil,
          :previousUri => String.t() | nil,
          :resultSetSize => String.t() | nil,
          :startPosition => String.t() | nil,
          :totalSetSize => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:notaryJournals, :list, DocuSign.Model.NotaryJournal)
  end
end
