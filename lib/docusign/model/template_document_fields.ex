# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TemplateDocumentFields do
  @moduledoc """
  Template document fields
  """

  @derive Jason.Encoder
  defstruct [
    :documentFields
  ]

  @type t :: %__MODULE__{
          :documentFields => [DocuSign.Model.NameValue.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:documentFields, :list, DocuSign.Model.NameValue)
  end
end
