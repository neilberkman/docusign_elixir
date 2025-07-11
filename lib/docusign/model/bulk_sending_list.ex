# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkSendingList do
  @moduledoc """
  This object contains the details for the bulk send list.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.BulkSendingCopy

  @derive Jason.Encoder
  defstruct [
    :bulkCopies,
    :listId,
    :name
  ]

  @type t :: %__MODULE__{
          :bulkCopies => [BulkSendingCopy.t()] | nil,
          :listId => String.t() | nil,
          :name => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:bulkCopies, :list, BulkSendingCopy)
  end
end
