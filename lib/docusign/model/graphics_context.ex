# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.GraphicsContext do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :fillColor,
    :lineColor,
    :lineWeight
  ]

  @type t :: %__MODULE__{
          :fillColor => String.t() | nil,
          :lineColor => String.t() | nil,
          :lineWeight => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.GraphicsContext do
  def decode(value, _options) do
    value
  end
end
