# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientUpdateResponse do
  @moduledoc """
  The recipient details that are returned after you update the recipient.
  """

  @derive Jason.Encoder
  defstruct [
    :combined,
    :errorDetails,
    :recipientId,
    :recipientIdGuid,
    :tabs
  ]

  @type t :: %__MODULE__{
          :combined => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :recipientId => String.t() | nil,
          :recipientIdGuid => String.t() | nil,
          :tabs => DocuSign.Model.EnvelopeRecipientTabs.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:tabs, :struct, DocuSign.Model.EnvelopeRecipientTabs)
  end
end
