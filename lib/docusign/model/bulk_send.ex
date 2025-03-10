# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkSend do
  @moduledoc """
  The bulk send list resource provides methods that enable you to create and manage bulk sending lists, which you can use to send multiple copies of an envelope in a single batch.   **Note:** The Bulk Send feature is only available on Business Pro and Enterprise Pro plans.
  """

  @derive Jason.Encoder
  defstruct [
    :bulkCopies,
    :listId,
    :name
  ]

  @type t :: %__MODULE__{
          :bulkCopies => [DocuSign.Model.BulkSendingCopy.t()] | nil,
          :listId => String.t() | nil,
          :name => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:bulkCopies, :list, DocuSign.Model.BulkSendingCopy)
  end
end
