# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Ssn4InformationInput do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :displayLevelCode,
    :receiveInResponse,
    :ssn4
  ]

  @type t :: %__MODULE__{
          :displayLevelCode => String.t() | nil,
          :receiveInResponse => String.t() | nil,
          :ssn4 => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.Ssn4InformationInput do
  def decode(value, _options) do
    value
  end
end
