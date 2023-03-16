# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AddOn do
  @moduledoc """
  Contains information about add ons.
  """

  @derive [Poison.Encoder]
  defstruct [
    :active,
    :addOnId,
    :id,
    :name
  ]

  @type t :: %__MODULE__{
          :active => String.t() | nil,
          :addOnId => String.t() | nil,
          :id => String.t() | nil,
          :name => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.AddOn do
  def decode(value, _options) do
    value
  end
end
