# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountPasswordLockoutDurationMinutes do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :maximumMinutes,
    :minimumMinutes
  ]

  @type t :: %__MODULE__{
          :maximumMinutes => String.t() | nil,
          :minimumMinutes => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.AccountPasswordLockoutDurationMinutes do
  def decode(value, _options) do
    value
  end
end
