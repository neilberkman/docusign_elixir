# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopePublishTransactionErrorRollup do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :count,
    :errorType
  ]

  @type t :: %__MODULE__{
          :count => String.t() | nil,
          :errorType => String.t() | nil
        }

  def decode(value) do
    value
  end
end
