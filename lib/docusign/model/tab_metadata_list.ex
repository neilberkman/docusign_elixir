# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TabMetadataList do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.TabMetadata

  @derive Jason.Encoder
  defstruct [
    :tabs
  ]

  @type t :: %__MODULE__{
          :tabs => [TabMetadata.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:tabs, :list, TabMetadata)
  end
end
