# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeAttachment do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :accessControl,
    :attachmentId,
    :attachmentType,
    :errorDetails,
    :label,
    :name
  ]

  @type t :: %__MODULE__{
          :accessControl => String.t() | nil,
          :attachmentId => String.t() | nil,
          :attachmentType => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :label => String.t() | nil,
          :name => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeAttachment do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
  end
end
