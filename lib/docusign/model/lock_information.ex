# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.LockInformation do
  @moduledoc """

  """

  @derive Jason.Encoder
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

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:lockedByUser, :struct, DocuSign.Model.UserInfo)
  end
end
