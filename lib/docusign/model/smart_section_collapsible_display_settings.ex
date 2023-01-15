# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.SmartSectionCollapsibleDisplaySettings do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :arrowClosed,
    :arrowColor,
    :arrowLocation,
    :arrowOpen,
    :arrowSize,
    :arrowStyle,
    :containerStyle,
    :labelStyle,
    :onlyArrowIsClickable,
    :outerLabelAndArrowStyle
  ]

  @type t :: %__MODULE__{
          :arrowClosed => String.t() | nil,
          :arrowColor => String.t() | nil,
          :arrowLocation => String.t() | nil,
          :arrowOpen => String.t() | nil,
          :arrowSize => String.t() | nil,
          :arrowStyle => String.t() | nil,
          :containerStyle => String.t() | nil,
          :labelStyle => String.t() | nil,
          :onlyArrowIsClickable => boolean() | nil,
          :outerLabelAndArrowStyle => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.SmartSectionCollapsibleDisplaySettings do
  def decode(value, _options) do
    value
  end
end
