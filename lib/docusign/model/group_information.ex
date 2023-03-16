# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.GroupInformation do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :endPosition,
    :groups,
    :nextUri,
    :previousUri,
    :resultSetSize,
    :startPosition,
    :totalSetSize
  ]

  @type t :: %__MODULE__{
          :endPosition => String.t() | nil,
          :groups => [DocuSign.Model.Group.t()] | nil,
          :nextUri => String.t() | nil,
          :previousUri => String.t() | nil,
          :resultSetSize => String.t() | nil,
          :startPosition => String.t() | nil,
          :totalSetSize => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.GroupInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:groups, :list, DocuSign.Model.Group, options)
  end
end
