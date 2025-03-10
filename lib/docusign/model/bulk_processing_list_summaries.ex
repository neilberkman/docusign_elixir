# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkProcessingListSummaries do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :bulkListSummaries
  ]

  @type t :: %__MODULE__{
          :bulkListSummaries => [DocuSign.Model.BulkProcessingListSummary.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :bulkListSummaries,
      :list,
      DocuSign.Model.BulkProcessingListSummary
    )
  end
end
