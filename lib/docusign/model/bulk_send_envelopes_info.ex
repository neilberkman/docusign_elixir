# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.BulkSendEnvelopesInfo do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :authoritativeCopy,
    :completed,
    :correct,
    :created,
    :declined,
    :deleted,
    :delivered,
    :digitalSignaturesPending,
    :sent,
    :signed,
    :timedOut,
    :transferCompleted,
    :voided
  ]

  @type t :: %__MODULE__{
    :authoritativeCopy => String.t | nil,
    :completed => String.t | nil,
    :correct => String.t | nil,
    :created => String.t | nil,
    :declined => String.t | nil,
    :deleted => String.t | nil,
    :delivered => String.t | nil,
    :digitalSignaturesPending => String.t | nil,
    :sent => String.t | nil,
    :signed => String.t | nil,
    :timedOut => String.t | nil,
    :transferCompleted => String.t | nil,
    :voided => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.BulkSendEnvelopesInfo do
  def decode(value, _options) do
    value
  end
end
