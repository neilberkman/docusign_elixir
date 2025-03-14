# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PowerFormsResponse do
  @moduledoc """
  A list of PowerForms.
  """

  @derive Jason.Encoder
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

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:powerForms, :list, DocuSign.Model.PowerForm)
  end
end
