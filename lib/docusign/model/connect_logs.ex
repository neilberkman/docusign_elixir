# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ConnectLogs do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :failures,
    :logs,
    :totalRecords,
    :type
  ]

  @type t :: %__MODULE__{
          :failures => [DocuSign.Model.ConnectLog.t()] | nil,
          :logs => [DocuSign.Model.ConnectLog.t()] | nil,
          :totalRecords => String.t() | nil,
          :type => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ConnectLogs do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:failures, :list, DocuSign.Model.ConnectLog, options)
    |> deserialize(:logs, :list, DocuSign.Model.ConnectLog, options)
  end
end
