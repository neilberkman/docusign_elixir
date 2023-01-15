# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeTemplateResults do
  @moduledoc """
  Information about templates.
  """

  @derive [Poison.Encoder]
  defstruct [
    :endPosition,
    :envelopeTemplates,
    :folders,
    :nextUri,
    :previousUri,
    :resultSetSize,
    :startPosition,
    :totalSetSize
  ]

  @type t :: %__MODULE__{
          :endPosition => String.t() | nil,
          :envelopeTemplates => [DocuSign.Model.EnvelopeTemplate.t()] | nil,
          :folders => [DocuSign.Model.Folder.t()] | nil,
          :nextUri => String.t() | nil,
          :previousUri => String.t() | nil,
          :resultSetSize => String.t() | nil,
          :startPosition => String.t() | nil,
          :totalSetSize => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeTemplateResults do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:envelopeTemplates, :list, DocuSign.Model.EnvelopeTemplate, options)
    |> deserialize(:folders, :list, DocuSign.Model.Folder, options)
  end
end
