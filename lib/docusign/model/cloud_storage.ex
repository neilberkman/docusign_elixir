# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.CloudStorage do
  @moduledoc """
  Cloud storage
  """

  @derive [Poison.Encoder]
  defstruct [
    :endPosition,
    :errorDetails,
    :id,
    :items,
    :name,
    :nextUri,
    :previousUri,
    :resultSetSize,
    :startPosition,
    :totalSetSize
  ]

  @type t :: %__MODULE__{
          :endPosition => String.t() | nil,
          :errorDetails => DocuSign.Model.ExternalDocServiceErrorDetails.t() | nil,
          :id => String.t() | nil,
          :items => [DocuSign.Model.ExternalFile.t()] | nil,
          :name => String.t() | nil,
          :nextUri => String.t() | nil,
          :previousUri => String.t() | nil,
          :resultSetSize => String.t() | nil,
          :startPosition => String.t() | nil,
          :totalSetSize => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.CloudStorage do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ExternalDocServiceErrorDetails, options)
    |> deserialize(:items, :list, DocuSign.Model.ExternalFile, options)
  end
end
