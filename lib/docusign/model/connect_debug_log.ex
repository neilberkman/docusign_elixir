# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ConnectDebugLog do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :connectConfig,
    :errorDetails,
    :eventDateTime,
    :eventDescription,
    :payload
  ]

  @type t :: %__MODULE__{
          :connectConfig => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :eventDateTime => String.t() | nil,
          :eventDescription => String.t() | nil,
          :payload => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
  end
end
