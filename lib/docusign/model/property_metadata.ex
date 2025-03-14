# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PropertyMetadata do
  @moduledoc """
  Metadata about a property.
  """

  @derive Jason.Encoder
  defstruct [
    :options,
    :rights
  ]

  @type t :: %__MODULE__{
          :options => [String.t()] | nil,
          :rights => String.t() | nil
        }

  def decode(value) do
    value
  end
end
