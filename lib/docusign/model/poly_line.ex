# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PolyLine do
  @moduledoc """

  """

  @derive Jason.Encoder
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

  def decode(value) do
    value
  end
end
