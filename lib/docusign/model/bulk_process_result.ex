# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkProcessResult do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :errors,
    :listId,
    :success
  ]

  @type t :: %__MODULE__{
          :errors => [DocuSign.Model.BulkSendBatchError.t()] | nil,
          :listId => String.t() | nil,
          :success => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BulkProcessResult do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:errors, :list, DocuSign.Model.BulkSendBatchError, options)
  end
end
