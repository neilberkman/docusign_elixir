# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.InlineTemplate do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :customFields,
    :documents,
    :envelope,
    :recipients,
    :sequence
  ]

  @type t :: %__MODULE__{
          :customFields => DocuSign.Model.AccountCustomFields.t() | nil,
          :documents => [DocuSign.Model.Document.t()] | nil,
          :envelope => DocuSign.Model.Envelope.t() | nil,
          :recipients => DocuSign.Model.EnvelopeRecipients.t() | nil,
          :sequence => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:customFields, :struct, DocuSign.Model.AccountCustomFields)
    |> Deserializer.deserialize(:documents, :list, DocuSign.Model.Document)
    |> Deserializer.deserialize(:envelope, :struct, DocuSign.Model.Envelope)
    |> Deserializer.deserialize(:recipients, :struct, DocuSign.Model.EnvelopeRecipients)
  end
end
