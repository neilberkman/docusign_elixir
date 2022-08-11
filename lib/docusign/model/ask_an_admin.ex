# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.AskAnAdmin do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :email,
    :message,
    :name,
    :phone
  ]

  @type t :: %__MODULE__{
    :email => String.t | nil,
    :message => String.t | nil,
    :name => String.t | nil,
    :phone => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.AskAnAdmin do
  def decode(value, _options) do
    value
  end
end
