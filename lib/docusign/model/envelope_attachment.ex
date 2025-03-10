# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeAttachment do
  @moduledoc """

  """

  @derive Jason.Encoder
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

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
  end
end
