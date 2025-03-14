# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PowerFormFormDataRecipient do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :email,
    :formData,
    :name,
    :recipientId
  ]

  @type t :: %__MODULE__{
          :email => String.t() | nil,
          :formData => [DocuSign.Model.NameValue.t()] | nil,
          :name => String.t() | nil,
          :recipientId => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:formData, :list, DocuSign.Model.NameValue)
  end
end
