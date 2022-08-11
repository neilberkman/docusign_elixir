# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.BulkProcessResponse do
  @moduledoc """
  
  """

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
    :batchId => String.t | nil,
    :batchName => String.t | nil,
    :batchSize => String.t | nil,
    :errorDetails => [String.t] | nil,
    :errors => [String.t] | nil,
    :queueLimit => String.t | nil,
    :totalQueued => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.BulkProcessResponse do
  def decode(value, _options) do
    value
  end
end
