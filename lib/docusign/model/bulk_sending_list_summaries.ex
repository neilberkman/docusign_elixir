# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkSendingListSummaries do
  @moduledoc """
  This complex type contains summaries that provide basic information about the bulk send lists that belong to the current user.
  """

  @derive [Poison.Encoder]
  defstruct [
    :bulkListSummaries
  ]

  @type t :: %__MODULE__{
          :bulkListSummaries => [DocuSign.Model.BulkSendingListSummary.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BulkSendingListSummaries do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:bulkListSummaries, :list, DocuSign.Model.BulkSendingListSummary, options)
  end
end
