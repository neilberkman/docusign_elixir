# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.SignatureUserDef do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :isDefault,
    :rights,
    :userId
  ]

  @type t :: %__MODULE__{
    :isDefault => String.t | nil,
    :rights => String.t | nil,
    :userId => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.SignatureUserDef do
  def decode(value, _options) do
    value
  end
end
