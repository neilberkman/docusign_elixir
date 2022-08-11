# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.ScheduledSending do
  @moduledoc """
  A complex element that specifies the scheduled sending settings for the envelope.
  """

  @derive [Poison.Encoder]
  defstruct [
    :bulkListId,
    :resumeDate,
    :rules,
    :status
  ]

  @type t :: %__MODULE__{
    :bulkListId => String.t | nil,
    :resumeDate => String.t | nil,
    :rules => [DocuSign.Model.EnvelopeDelayRule.t] | nil,
    :status => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.ScheduledSending do
  import DocuSign.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:rules, :list, DocuSign.Model.EnvelopeDelayRule, options)
  end
end
