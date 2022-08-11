# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.SignatureUser do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :isDefault,
    :rights,
    :userId,
    :userName
  ]

  @type t :: %__MODULE__{
    :isDefault => String.t | nil,
    :rights => String.t | nil,
    :userId => String.t | nil,
    :userName => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.SignatureUser do
  def decode(value, _options) do
    value
  end
end
