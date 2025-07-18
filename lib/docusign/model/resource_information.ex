# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ResourceInformation do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.NameValue

  @derive Jason.Encoder
  defstruct [
    :resources
  ]

  @type t :: %__MODULE__{
          :resources => [NameValue.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:resources, :list, NameValue)
  end
end
