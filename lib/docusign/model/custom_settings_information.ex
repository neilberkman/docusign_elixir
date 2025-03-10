# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.CustomSettingsInformation do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :customSettings
  ]

  @type t :: %__MODULE__{
          :customSettings => [DocuSign.Model.NameValue.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:customSettings, :list, DocuSign.Model.NameValue)
  end
end
