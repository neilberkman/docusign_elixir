# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkProcessRequest do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :batchName,
    :envelopeOrTemplateId
  ]

  @type t :: %__MODULE__{
          :batchName => String.t() | nil,
          :envelopeOrTemplateId => String.t() | nil
        }

  def decode(value) do
    value
  end
end
