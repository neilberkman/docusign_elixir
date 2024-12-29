# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountMinimumPasswordLength do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :maximumLength,
    :minimumLength
  ]

  @type t :: %__MODULE__{
          :maximumLength => String.t() | nil,
          :minimumLength => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.AccountMinimumPasswordLength do
  def decode(value, _options) do
    value
  end
end
