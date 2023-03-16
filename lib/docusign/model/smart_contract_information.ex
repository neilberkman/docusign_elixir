# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.SmartContractInformation do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :code,
    :uri
  ]

  @type t :: %__MODULE__{
          :code => String.t() | nil,
          :uri => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.SmartContractInformation do
  def decode(value, _options) do
    value
  end
end
