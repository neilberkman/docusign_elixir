# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TemplateCustomFields do
  @moduledoc """
  A template custom field enables you to prepopulate custom metadata for all new envelopes that are created by using a specific template. You can then use the custom data for sorting, organizing, searching, and other downstream processes.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.ListCustomField
  alias DocuSign.Model.TextCustomField

  @derive Jason.Encoder
  defstruct [
    :listCustomFields,
    :textCustomFields
  ]

  @type t :: %__MODULE__{
          :listCustomFields => [ListCustomField.t()] | nil,
          :textCustomFields => [TextCustomField.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:listCustomFields, :list, ListCustomField)
    |> Deserializer.deserialize(:textCustomFields, :list, TextCustomField)
  end
end
