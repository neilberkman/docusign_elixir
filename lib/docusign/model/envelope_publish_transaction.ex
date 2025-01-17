# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopePublishTransaction do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :applyConnectSettings,
    :envelopeCount,
    :envelopeLevelErrorRollups,
    :envelopePublishTransactionId,
    :errorCount,
    :fileLevelErrors,
    :noActionRequiredEnvelopeCount,
    :processedEnvelopeCount,
    :processingStatus,
    :resultsUri,
    :submissionDate,
    :submittedByUserInfo,
    :submittedForPublishingEnvelopeCount
  ]

  @type t :: %__MODULE__{
          :applyConnectSettings => String.t() | nil,
          :envelopeCount => String.t() | nil,
          :envelopeLevelErrorRollups =>
            [DocuSign.Model.EnvelopePublishTransactionErrorRollup.t()] | nil,
          :envelopePublishTransactionId => String.t() | nil,
          :errorCount => String.t() | nil,
          :fileLevelErrors => [String.t()] | nil,
          :noActionRequiredEnvelopeCount => String.t() | nil,
          :processedEnvelopeCount => String.t() | nil,
          :processingStatus => String.t() | nil,
          :resultsUri => String.t() | nil,
          :submissionDate => String.t() | nil,
          :submittedByUserInfo => DocuSign.Model.UserInfo.t() | nil,
          :submittedForPublishingEnvelopeCount => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopePublishTransaction do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :envelopeLevelErrorRollups,
      :list,
      DocuSign.Model.EnvelopePublishTransactionErrorRollup,
      options
    )
    |> deserialize(:submittedByUserInfo, :struct, DocuSign.Model.UserInfo, options)
  end
end
