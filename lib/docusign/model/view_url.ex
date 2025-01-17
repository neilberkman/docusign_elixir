# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ViewUrl do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :url
  ]

  @type t :: %__MODULE__{
          :url => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ViewUrl do
  def decode(value, _options) do
    value
  end
end
