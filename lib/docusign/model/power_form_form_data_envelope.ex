# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PowerFormFormDataEnvelope do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.PowerFormFormDataRecipient

  @derive Jason.Encoder
  defstruct [
    :envelopeId,
    :recipients
  ]

  @type t :: %__MODULE__{
          :envelopeId => String.t() | nil,
          :recipients => [PowerFormFormDataRecipient.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:recipients, :list, PowerFormFormDataRecipient)
  end
end
