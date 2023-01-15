# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PowerFormsResponse do
  @moduledoc """
  A list of PowerForms.
  """

  @derive [Poison.Encoder]
  defstruct [
    :endPosition,
    :nextUri,
    :powerForms,
    :previousUri,
    :resultSetSize,
    :startPosition,
    :totalSetSize
  ]

  @type t :: %__MODULE__{
          :endPosition => integer() | nil,
          :nextUri => String.t() | nil,
          :powerForms => [DocuSign.Model.PowerForm.t()] | nil,
          :previousUri => String.t() | nil,
          :resultSetSize => integer() | nil,
          :startPosition => integer() | nil,
          :totalSetSize => integer() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PowerFormsResponse do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:powerForms, :list, DocuSign.Model.PowerForm, options)
  end
end
