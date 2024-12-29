# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ConnectUserInfo do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :email,
    :isIncluded,
    :userId,
    :userName
  ]

  @type t :: %__MODULE__{
          :email => String.t() | nil,
          :isIncluded => String.t() | nil,
          :userId => String.t() | nil,
          :userName => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ConnectUserInfo do
  def decode(value, _options) do
    value
  end
end
