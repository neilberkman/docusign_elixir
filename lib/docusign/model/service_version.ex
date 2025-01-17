# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ServiceVersion do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :version,
    :versionUrl
  ]

  @type t :: %__MODULE__{
          :version => String.t() | nil,
          :versionUrl => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ServiceVersion do
  def decode(value, _options) do
    value
  end
end
