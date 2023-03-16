# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.FileType do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :fileExtension,
    :mimeType
  ]

  @type t :: %__MODULE__{
          :fileExtension => String.t() | nil,
          :mimeType => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.FileType do
  def decode(value, _options) do
    value
  end
end
