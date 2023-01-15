# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Watermark do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :displayAngle,
    :enabled,
    :font,
    :fontColor,
    :fontSize,
    :id,
    :imageBase64,
    :transparency,
    :watermarkText
  ]

  @type t :: %__MODULE__{
          :displayAngle => String.t() | nil,
          :enabled => String.t() | nil,
          :font => String.t() | nil,
          :fontColor => String.t() | nil,
          :fontSize => String.t() | nil,
          :id => String.t() | nil,
          :imageBase64 => String.t() | nil,
          :transparency => String.t() | nil,
          :watermarkText => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.Watermark do
  def decode(value, _options) do
    value
  end
end
