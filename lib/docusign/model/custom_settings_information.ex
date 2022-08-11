# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.CustomSettingsInformation do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :customSettings
  ]

  @type t :: %__MODULE__{
    :customSettings => [DocuSign.Model.NameValue.t] | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.CustomSettingsInformation do
  import DocuSign.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:customSettings, :list, DocuSign.Model.NameValue, options)
  end
end
