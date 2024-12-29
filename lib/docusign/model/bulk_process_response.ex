# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkProcessResponse do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :batchId,
    :batchName,
    :batchSize,
    :errorDetails,
    :errors,
    :queueLimit,
    :totalQueued
  ]

  @type t :: %__MODULE__{
          :batchId => String.t() | nil,
          :batchName => String.t() | nil,
          :batchSize => String.t() | nil,
          :errorDetails => [String.t()] | nil,
          :errors => [String.t()] | nil,
          :queueLimit => String.t() | nil,
          :totalQueued => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BulkProcessResponse do
  def decode(value, _options) do
    value
  end
end
