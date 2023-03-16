# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TemplateNotificationRequest do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :expirations,
    :password,
    :reminders,
    :useAccountDefaults
  ]

  @type t :: %__MODULE__{
          :expirations => DocuSign.Model.Expirations.t() | nil,
          :password => String.t() | nil,
          :reminders => DocuSign.Model.Reminders.t() | nil,
          :useAccountDefaults => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.TemplateNotificationRequest do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:expirations, :struct, DocuSign.Model.Expirations, options)
    |> deserialize(:reminders, :struct, DocuSign.Model.Reminders, options)
  end
end
