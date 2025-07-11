# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PowerFormsResponse do
  @moduledoc """
  A list of PowerForms.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.PowerForm

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
          :powerForms => [PowerForm.t()] | nil,
          :previousUri => String.t() | nil,
          :resultSetSize => integer() | nil,
          :startPosition => integer() | nil,
          :totalSetSize => integer() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:powerForms, :list, PowerForm)
  end
end
