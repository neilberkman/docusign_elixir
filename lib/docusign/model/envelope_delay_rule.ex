# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeDelayRule do
  @moduledoc """
  A user-specified object that describes the envelope delay.  To indicate a relative delay, use `delay`. To indicate the exact datetime the envelope should be sent, use `resumeDate`. Only one of the two properties can be used.
  """

  @derive [Poison.Encoder]
  defstruct [
    :delay,
    :resumeDate
  ]

  @type t :: %__MODULE__{
          :delay => String.t() | nil,
          :resumeDate => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeDelayRule do
  def decode(value, _options) do
    value
  end
end
