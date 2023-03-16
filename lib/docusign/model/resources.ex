# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Resources do
  @moduledoc """
  API resource information
  """

  @derive [Poison.Encoder]
  defstruct [
    :resources
  ]

  @type t :: %__MODULE__{
          :resources => [DocuSign.Model.NameValue.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.Resources do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:resources, :list, DocuSign.Model.NameValue, options)
  end
end
