# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ConditionalRecipientRuleFilter do
  @moduledoc """

  """

  @derive Jason.Encoder
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

  def decode(value) do
    value
  end
end
