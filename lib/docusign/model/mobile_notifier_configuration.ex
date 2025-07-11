# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.MobileNotifierConfiguration do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.ErrorDetails

  @derive Jason.Encoder
  defstruct [
    :deviceId,
    :errorDetails,
    :platform
  ]

  @type t :: %__MODULE__{
          :deviceId => String.t() | nil,
          :errorDetails => ErrorDetails.t() | nil,
          :platform => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, ErrorDetails)
  end
end
