# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PageImages do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :endPosition,
    :nextUri,
    :pages,
    :previousUri,
    :resultSetSize,
    :startPosition,
    :totalSetSize
  ]

  @type t :: %__MODULE__{
          :endPosition => String.t() | nil,
          :nextUri => String.t() | nil,
          :pages => [DocuSign.Model.Page.t()] | nil,
          :previousUri => String.t() | nil,
          :resultSetSize => String.t() | nil,
          :startPosition => String.t() | nil,
          :totalSetSize => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PageImages do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:pages, :list, DocuSign.Model.Page, options)
  end
end
