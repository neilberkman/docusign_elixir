# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientsUpdateSummary do
  @moduledoc """
  This is the response that the API returns after you update recipients.
  """

  @derive Jason.Encoder
  defstruct [
    :recipientUpdateResults
  ]

  @type t :: %__MODULE__{
          :recipientUpdateResults => [DocuSign.Model.RecipientUpdateResponse.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :recipientUpdateResults,
      :list,
      DocuSign.Model.RecipientUpdateResponse
    )
  end
end
