# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DocumentHtmlDisplaySettings do
  @moduledoc """
  This object defines how to display the HTML between the `startAnchor` and `endAnchor`.
  """

  @derive Jason.Encoder
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
          :collapsibleSettings => DocuSign.Model.DocumentHtmlCollapsibleDisplaySettings.t() | nil,
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

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :collapsibleSettings,
      :struct,
      DocuSign.Model.DocumentHtmlCollapsibleDisplaySettings
    )
  end
end
