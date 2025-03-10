# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DiagnosticsSettingsInformation do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :apiRequestLogging,
    :apiRequestLogMaxEntries,
    :apiRequestLogRemainingEntries
  ]

  @type t :: %__MODULE__{
          :apiRequestLogging => String.t() | nil,
          :apiRequestLogMaxEntries => String.t() | nil,
          :apiRequestLogRemainingEntries => String.t() | nil
        }

  def decode(value) do
    value
  end
end
