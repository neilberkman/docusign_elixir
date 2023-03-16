# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DelegationInfo do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :email,
    :name,
    :userAuthorizationId,
    :userId
  ]

  @type t :: %__MODULE__{
          :email => String.t() | nil,
          :name => String.t() | nil,
          :userAuthorizationId => String.t() | nil,
          :userId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.DelegationInfo do
  def decode(value, _options) do
    value
  end
end
