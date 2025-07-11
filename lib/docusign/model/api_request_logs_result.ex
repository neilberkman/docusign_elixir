# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ApiRequestLogsResult do
  @moduledoc """
  Contains information about multiple API request logs.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.ApiRequestLog

  @derive Jason.Encoder
  defstruct [
    :apiRequestLogs
  ]

  @type t :: %__MODULE__{
          :apiRequestLogs => [ApiRequestLog.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:apiRequestLogs, :list, ApiRequestLog)
  end
end
