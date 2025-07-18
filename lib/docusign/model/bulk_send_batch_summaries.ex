# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkSendBatchSummaries do
  @moduledoc """
  A list of bulk send batch summaries.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.BulkSendBatchSummary

  @derive Jason.Encoder
  defstruct [
    :batchSizeLimit,
    :bulkBatchSummaries,
    :bulkProcessQueueLimit,
    :bulkProcessTotalQueued,
    :endPosition,
    :nextUri,
    :previousUri,
    :queueLimit,
    :resultSetSize,
    :startPosition,
    :totalQueued,
    :totalSetSize
  ]

  @type t :: %__MODULE__{
          :batchSizeLimit => String.t() | nil,
          :bulkBatchSummaries => [BulkSendBatchSummary.t()] | nil,
          :bulkProcessQueueLimit => String.t() | nil,
          :bulkProcessTotalQueued => String.t() | nil,
          :endPosition => String.t() | nil,
          :nextUri => String.t() | nil,
          :previousUri => String.t() | nil,
          :queueLimit => String.t() | nil,
          :resultSetSize => String.t() | nil,
          :startPosition => String.t() | nil,
          :totalQueued => String.t() | nil,
          :totalSetSize => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:bulkBatchSummaries, :list, BulkSendBatchSummary)
  end
end
