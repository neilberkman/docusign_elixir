# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.CustomFields do
  @moduledoc """
  Contains information about custom fields.
  """

  @derive [Poison.Encoder]
  defstruct [
    :listCustomFields,
    :textCustomFields
  ]

  @type t :: %__MODULE__{
    :listCustomFields => [DocuSign.Model.ListCustomField.t] | nil,
    :textCustomFields => [DocuSign.Model.TextCustomField.t] | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.CustomFields do
  import DocuSign.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:listCustomFields, :list, DocuSign.Model.ListCustomField, options)
    |> deserialize(:textCustomFields, :list, DocuSign.Model.TextCustomField, options)
  end
end
