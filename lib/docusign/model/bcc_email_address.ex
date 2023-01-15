# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BccEmailAddress do
  @moduledoc """
  Contains information about the BCC email address.
  """

  @derive [Poison.Encoder]
  defstruct [
    :bccEmailAddressId,
    :email
  ]

  @type t :: %__MODULE__{
          :bccEmailAddressId => String.t() | nil,
          :email => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BccEmailAddress do
  def decode(value, _options) do
    value
  end
end
