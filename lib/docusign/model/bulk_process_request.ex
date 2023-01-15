# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkProcessRequest do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :batchName,
    :envelopeOrTemplateId
  ]

  @type t :: %__MODULE__{
          :batchName => String.t() | nil,
          :envelopeOrTemplateId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BulkProcessRequest do
  def decode(value, _options) do
    value
  end
end
