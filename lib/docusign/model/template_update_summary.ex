# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.TemplateUpdateSummary do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :bulkEnvelopeStatus,
    :envelopeId,
    :errorDetails,
    :listCustomFieldUpdateResults,
    :lockInformation,
    :recipientUpdateResults,
    :tabUpdateResults,
    :textCustomFieldUpdateResults
  ]

  @type t :: %__MODULE__{
          :bulkEnvelopeStatus => BulkEnvelopeStatus,
          :envelopeId => String.t(),
          :errorDetails => ErrorDetails,
          :listCustomFieldUpdateResults => [ListCustomField],
          :lockInformation => EnvelopeLocks,
          :recipientUpdateResults => [RecipientUpdateResponse],
          :tabUpdateResults => EnvelopeRecipientTabs,
          :textCustomFieldUpdateResults => [TextCustomField]
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.TemplateUpdateSummary do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:bulkEnvelopeStatus, :struct, DocuSign.Model.BulkEnvelopeStatus, options)
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
    |> deserialize(:listCustomFieldUpdateResults, :list, DocuSign.Model.ListCustomField, options)
    |> deserialize(:lockInformation, :struct, DocuSign.Model.EnvelopeLocks, options)
    |> deserialize(
      :recipientUpdateResults,
      :list,
      DocuSign.Model.RecipientUpdateResponse,
      options
    )
    |> deserialize(:tabUpdateResults, :struct, DocuSign.Model.EnvelopeRecipientTabs, options)
    |> deserialize(:textCustomFieldUpdateResults, :list, DocuSign.Model.TextCustomField, options)
  end
end