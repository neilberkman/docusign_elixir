# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PropertyMetadata do
  @moduledoc """
  Metadata about a property.
  """

  @derive [Poison.Encoder]
  defstruct [
    :options,
    :rights
  ]

  @type t :: %__MODULE__{
          :options => [String.t()] | nil,
          :rights => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PropertyMetadata do
  def decode(value, _options) do
    value
  end
end
