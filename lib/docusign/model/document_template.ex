# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DocumentTemplate do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :documentEndPage,
    :documentId,
    :documentStartPage,
    :errorDetails,
    :templateId
  ]

  @type t :: %__MODULE__{
          :documentEndPage => String.t() | nil,
          :documentId => String.t() | nil,
          :documentStartPage => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :templateId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.DocumentTemplate do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
  end
end
