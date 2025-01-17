# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PayPalLegacySettings do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :currency,
    :partner,
    :password,
    :userName,
    :vendor
  ]

  @type t :: %__MODULE__{
          :currency => String.t() | nil,
          :partner => String.t() | nil,
          :password => String.t() | nil,
          :userName => String.t() | nil,
          :vendor => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PayPalLegacySettings do
  def decode(value, _options) do
    value
  end
end
