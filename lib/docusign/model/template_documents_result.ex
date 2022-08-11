# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.TemplateDocumentsResult do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :templateDocuments,
    :templateId
  ]

  @type t :: %__MODULE__{
    :templateDocuments => [DocuSign.Model.EnvelopeDocument.t] | nil,
    :templateId => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.TemplateDocumentsResult do
  import DocuSign.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:templateDocuments, :list, DocuSign.Model.EnvelopeDocument, options)
  end
end
