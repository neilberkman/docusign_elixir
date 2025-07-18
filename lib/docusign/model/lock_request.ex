# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.LockRequest do
  @moduledoc """
  This request object contains information about the lock that you want to create or update.
  """

  @derive Jason.Encoder
  defstruct [
    :lockDurationInSeconds,
    :lockType,
    :lockedByApp,
    :templatePassword,
    :useScratchPad
  ]

  @type t :: %__MODULE__{
          :lockDurationInSeconds => String.t() | nil,
          :lockType => String.t() | nil,
          :lockedByApp => String.t() | nil,
          :templatePassword => String.t() | nil,
          :useScratchPad => String.t() | nil
        }

  def decode(value) do
    value
  end
end
