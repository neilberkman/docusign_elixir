# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ChunkedUploadRequest do
  @moduledoc """
  This is the request object for uploading a chunked upload.
  """

  @derive [Poison.Encoder]
  defstruct [
    :chunkedUploadId,
    :data
  ]

  @type t :: %__MODULE__{
          :chunkedUploadId => String.t() | nil,
          :data => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ChunkedUploadRequest do
  def decode(value, _options) do
    value
  end
end
