# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeAttachmentsResult do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :attachments
  ]

  @type t :: %__MODULE__{
          :attachments => [DocuSign.Model.EnvelopeAttachment.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeAttachmentsResult do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:attachments, :list, DocuSign.Model.EnvelopeAttachment, options)
  end
end
