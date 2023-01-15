# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PrefillFormData do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :formData,
    :senderEmail,
    :senderName,
    :senderUserId
  ]

  @type t :: %__MODULE__{
          :formData => [DocuSign.Model.FormDataItem.t()] | nil,
          :senderEmail => String.t() | nil,
          :senderName => String.t() | nil,
          :senderUserId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.PrefillFormData do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:formData, :list, DocuSign.Model.FormDataItem, options)
  end
end
