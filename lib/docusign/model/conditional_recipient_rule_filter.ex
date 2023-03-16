# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ConditionalRecipientRuleFilter do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :operator,
    :recipientId,
    :scope,
    :tabId,
    :tabLabel,
    :tabType,
    :value
  ]

  @type t :: %__MODULE__{
          :operator => String.t() | nil,
          :recipientId => String.t() | nil,
          :scope => String.t() | nil,
          :tabId => String.t() | nil,
          :tabLabel => String.t() | nil,
          :tabType => String.t() | nil,
          :value => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ConditionalRecipientRuleFilter do
  def decode(value, _options) do
    value
  end
end
