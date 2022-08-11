# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.RecipientGroup do
  @moduledoc """
  Describes a group of recipients.
  """

  @derive [Poison.Encoder]
  defstruct [
    :groupMessage,
    :groupName,
    :recipients
  ]

  @type t :: %__MODULE__{
    :groupMessage => String.t | nil,
    :groupName => String.t | nil,
    :recipients => [DocuSign.Model.RecipientOption.t] | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.RecipientGroup do
  import DocuSign.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:recipients, :list, DocuSign.Model.RecipientOption, options)
  end
end
