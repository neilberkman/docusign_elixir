# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PowerFormsRequest do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.PowerForm

  @derive Jason.Encoder
  defstruct [
    :powerForms
  ]

  @type t :: %__MODULE__{
          :powerForms => [PowerForm.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:powerForms, :list, PowerForm)
  end
end
