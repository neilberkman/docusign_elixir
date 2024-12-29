# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeTransferRuleInformation do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :endPosition,
    :envelopeTransferRules,
    :nextUri,
    :previousUri,
    :resultSetSize,
    :startPosition,
    :totalSetSize
  ]

  @type t :: %__MODULE__{
          :endPosition => String.t() | nil,
          :envelopeTransferRules => [DocuSign.Model.EnvelopeTransferRule.t()] | nil,
          :nextUri => String.t() | nil,
          :previousUri => String.t() | nil,
          :resultSetSize => String.t() | nil,
          :startPosition => String.t() | nil,
          :totalSetSize => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeTransferRuleInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:envelopeTransferRules, :list, DocuSign.Model.EnvelopeTransferRule, options)
  end
end
