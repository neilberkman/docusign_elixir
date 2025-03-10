# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Notification do
  @moduledoc """
  A complex element that specifies the notification settings for the envelope.
  """

  @derive Jason.Encoder
  defstruct [
    :expirations,
    :reminders,
    :useAccountDefaults
  ]

  @type t :: %__MODULE__{
          :expirations => DocuSign.Model.Expirations.t() | nil,
          :reminders => DocuSign.Model.Reminders.t() | nil,
          :useAccountDefaults => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:expirations, :struct, DocuSign.Model.Expirations)
    |> Deserializer.deserialize(:reminders, :struct, DocuSign.Model.Reminders)
  end
end
