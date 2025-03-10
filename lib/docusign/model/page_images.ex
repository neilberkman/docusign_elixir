# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PageImages do
  @moduledoc """

  """

  @derive Jason.Encoder
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

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:pages, :list, DocuSign.Model.Page)
  end
end
