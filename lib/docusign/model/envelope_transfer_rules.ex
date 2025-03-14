# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeTransferRules do
  @moduledoc """
  This resource provides methods that enable account administrators to create and manage envelope transfer rules.
  """

  @derive Jason.Encoder
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

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :envelopeTransferRules,
      :list,
      DocuSign.Model.EnvelopeTransferRule
    )
  end
end
