# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PolyLine do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :x1,
    :x2,
    :y1,
    :y2
  ]

  @type t :: %__MODULE__{
          :x1 => String.t() | nil,
          :x2 => String.t() | nil,
          :y1 => String.t() | nil,
          :y2 => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PolyLine do
  def decode(value, _options) do
    value
  end
end
