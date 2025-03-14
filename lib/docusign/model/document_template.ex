# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DocumentTemplate do
  @moduledoc """

  """

  @derive Jason.Encoder
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

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
  end
end
