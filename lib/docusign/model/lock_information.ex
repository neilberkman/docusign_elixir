# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.LockInformation do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :errorDetails,
    :lockDurationInSeconds,
    :lockedByApp,
    :lockedByUser,
    :lockedUntilDateTime,
    :lockToken,
    :lockType,
    :useScratchPad
  ]

  @type t :: %__MODULE__{
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :lockDurationInSeconds => String.t() | nil,
          :lockedByApp => String.t() | nil,
          :lockedByUser => DocuSign.Model.UserInfo.t() | nil,
          :lockedUntilDateTime => String.t() | nil,
          :lockToken => String.t() | nil,
          :lockType => String.t() | nil,
          :useScratchPad => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.LockInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
    |> deserialize(:lockedByUser, :struct, DocuSign.Model.UserInfo, options)
  end
end
