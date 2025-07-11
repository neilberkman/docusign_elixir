# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RequestLogs do
  @moduledoc """
  Request logs
  """

  @derive Jason.Encoder
  defstruct [
    :apiRequestLogMaxEntries,
    :apiRequestLogRemainingEntries,
    :apiRequestLogging
  ]

  @type t :: %__MODULE__{
          :apiRequestLogMaxEntries => String.t() | nil,
          :apiRequestLogRemainingEntries => String.t() | nil,
          :apiRequestLogging => String.t() | nil
        }

  def decode(value) do
    value
  end
end
