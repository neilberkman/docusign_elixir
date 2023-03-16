# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TabMetadataList do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :tabs
  ]

  @type t :: %__MODULE__{
          :tabs => [DocuSign.Model.TabMetadata.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.TabMetadataList do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:tabs, :list, DocuSign.Model.TabMetadata, options)
  end
end
