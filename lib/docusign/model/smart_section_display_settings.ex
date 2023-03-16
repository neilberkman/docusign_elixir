# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.SmartSectionDisplaySettings do
  @moduledoc """
  These properties define how a Smart Section displays. A Smart Section is a type of display section.
  """

  @derive [Poison.Encoder]
  defstruct [
    :cellStyle,
    :collapsibleSettings,
    :display,
    :displayLabel,
    :displayOrder,
    :displayPageNumber,
    :hideLabelWhenOpened,
    :inlineOuterStyle,
    :labelWhenOpened,
    :preLabel,
    :scrollToTopWhenOpened,
    :tableStyle
  ]

  @type t :: %__MODULE__{
          :cellStyle => String.t() | nil,
          :collapsibleSettings => DocuSign.Model.SmartSectionCollapsibleDisplaySettings.t() | nil,
          :display => String.t() | nil,
          :displayLabel => String.t() | nil,
          :displayOrder => integer() | nil,
          :displayPageNumber => integer() | nil,
          :hideLabelWhenOpened => boolean() | nil,
          :inlineOuterStyle => String.t() | nil,
          :labelWhenOpened => String.t() | nil,
          :preLabel => String.t() | nil,
          :scrollToTopWhenOpened => boolean() | nil,
          :tableStyle => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.SmartSectionDisplaySettings do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :collapsibleSettings,
      :struct,
      DocuSign.Model.SmartSectionCollapsibleDisplaySettings,
      options
    )
  end
end
