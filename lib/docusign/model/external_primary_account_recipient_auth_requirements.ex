# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ExternalPrimaryAccountRecipientAuthRequirements do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :accessCode,
    :idVerification,
    :kba,
    :phone
  ]

  @type t :: %__MODULE__{
          :accessCode => String.t() | nil,
          :idVerification => String.t() | nil,
          :kba => String.t() | nil,
          :phone => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ExternalPrimaryAccountRecipientAuthRequirements do
  def decode(value, _options) do
    value
  end
end
