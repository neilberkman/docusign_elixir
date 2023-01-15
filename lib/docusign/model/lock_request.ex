# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.LockRequest do
  @moduledoc """
  This request object contains information about the lock that you want to create or update.
  """

  @derive [Poison.Encoder]
  defstruct [
    :lockDurationInSeconds,
    :lockedByApp,
    :lockType,
    :templatePassword,
    :useScratchPad
  ]

  @type t :: %__MODULE__{
          :lockDurationInSeconds => String.t() | nil,
          :lockedByApp => String.t() | nil,
          :lockType => String.t() | nil,
          :templatePassword => String.t() | nil,
          :useScratchPad => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.LockRequest do
  def decode(value, _options) do
    value
  end
end
