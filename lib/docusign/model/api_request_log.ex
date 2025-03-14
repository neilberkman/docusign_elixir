# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ApiRequestLog do
  @moduledoc """
  Contains API request log information.
  """

  @derive Jason.Encoder
  defstruct [
    :createdDateTime,
    :description,
    :requestLogId,
    :status
  ]

  @type t :: %__MODULE__{
          :createdDateTime => String.t() | nil,
          :description => String.t() | nil,
          :requestLogId => String.t() | nil,
          :status => String.t() | nil
        }

  def decode(value) do
    value
  end
end
