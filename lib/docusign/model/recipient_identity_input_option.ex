# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientIdentityInputOption do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :name,
    :phoneNumberList,
    :stringValue,
    :valueType
  ]

  @type t :: %__MODULE__{
          :name => String.t() | nil,
          :phoneNumberList => [DocuSign.Model.RecipientIdentityPhoneNumber.t()] | nil,
          :stringValue => String.t() | nil,
          :valueType => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :phoneNumberList,
      :list,
      DocuSign.Model.RecipientIdentityPhoneNumber
    )
  end
end
