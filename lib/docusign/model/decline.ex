# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Decline do
  @moduledoc """
  A tab that allows the recipient the option of declining an envelope. If the recipient clicks the tab during the signing process, the envelope is voided. 
  """

  @derive Jason.Encoder
  defstruct [
    :anchorAllowWhiteSpaceInCharacters,
    :anchorAllowWhiteSpaceInCharactersMetadata,
    :anchorCaseSensitive,
    :anchorCaseSensitiveMetadata,
    :anchorHorizontalAlignment,
    :anchorHorizontalAlignmentMetadata,
    :anchorIgnoreIfNotPresent,
    :anchorIgnoreIfNotPresentMetadata,
    :anchorMatchWholeWord,
    :anchorMatchWholeWordMetadata,
    :anchorString,
    :anchorStringMetadata,
    :anchorTabProcessorVersion,
    :anchorTabProcessorVersionMetadata,
    :anchorUnits,
    :anchorUnitsMetadata,
    :anchorXOffset,
    :anchorXOffsetMetadata,
    :anchorYOffset,
    :anchorYOffsetMetadata,
    :bold,
    :boldMetadata,
    :buttonText,
    :buttonTextMetadata,
    :caption,
    :captionMetadata,
    :conditionalParentLabel,
    :conditionalParentLabelMetadata,
    :conditionalParentValue,
    :conditionalParentValueMetadata,
    :customTabId,
    :customTabIdMetadata,
    :declineReason,
    :declineReasonMetadata,
    :documentId,
    :documentIdMetadata,
    :errorDetails,
    :font,
    :fontColor,
    :fontColorMetadata,
    :fontMetadata,
    :fontSize,
    :fontSizeMetadata,
    :formOrder,
    :formOrderMetadata,
    :formPageLabel,
    :formPageLabelMetadata,
    :formPageNumber,
    :formPageNumberMetadata,
    :height,
    :heightMetadata,
    :italic,
    :italicMetadata,
    :localePolicy,
    :mergeField,
    :mergeFieldXml,
    :pageNumber,
    :pageNumberMetadata,
    :recipientId,
    :recipientIdGuid,
    :recipientIdGuidMetadata,
    :recipientIdMetadata,
    :smartContractInformation,
    :source,
    :status,
    :statusMetadata,
    :tabGroupLabels,
    :tabGroupLabelsMetadata,
    :tabId,
    :tabIdMetadata,
    :tabLabel,
    :tabLabelMetadata,
    :tabOrder,
    :tabOrderMetadata,
    :tabType,
    :tabTypeMetadata,
    :templateLocked,
    :templateLockedMetadata,
    :templateRequired,
    :templateRequiredMetadata,
    :tooltip,
    :toolTipMetadata,
    :underline,
    :underlineMetadata,
    :warningDetails,
    :width,
    :widthMetadata,
    :xPosition,
    :xPositionMetadata,
    :yPosition,
    :yPositionMetadata
  ]

  @type t :: %__MODULE__{
          :anchorAllowWhiteSpaceInCharacters => String.t() | nil,
          :anchorAllowWhiteSpaceInCharactersMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :anchorCaseSensitive => String.t() | nil,
          :anchorCaseSensitiveMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :anchorHorizontalAlignment => String.t() | nil,
          :anchorHorizontalAlignmentMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :anchorIgnoreIfNotPresent => String.t() | nil,
          :anchorIgnoreIfNotPresentMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :anchorMatchWholeWord => String.t() | nil,
          :anchorMatchWholeWordMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :anchorString => String.t() | nil,
          :anchorStringMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :anchorTabProcessorVersion => String.t() | nil,
          :anchorTabProcessorVersionMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :anchorUnits => String.t() | nil,
          :anchorUnitsMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :anchorXOffset => String.t() | nil,
          :anchorXOffsetMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :anchorYOffset => String.t() | nil,
          :anchorYOffsetMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :bold => String.t() | nil,
          :boldMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :buttonText => String.t() | nil,
          :buttonTextMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :caption => String.t() | nil,
          :captionMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :conditionalParentLabel => String.t() | nil,
          :conditionalParentLabelMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :conditionalParentValue => String.t() | nil,
          :conditionalParentValueMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :customTabId => String.t() | nil,
          :customTabIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :declineReason => String.t() | nil,
          :declineReasonMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :documentId => String.t() | nil,
          :documentIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :font => String.t() | nil,
          :fontColor => String.t() | nil,
          :fontColorMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :fontMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :fontSize => String.t() | nil,
          :fontSizeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :formOrder => String.t() | nil,
          :formOrderMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :formPageLabel => String.t() | nil,
          :formPageLabelMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :formPageNumber => String.t() | nil,
          :formPageNumberMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :height => String.t() | nil,
          :heightMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :italic => String.t() | nil,
          :italicMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :localePolicy => DocuSign.Model.LocalePolicyTab.t() | nil,
          :mergeField => DocuSign.Model.MergeField.t() | nil,
          :mergeFieldXml => String.t() | nil,
          :pageNumber => String.t() | nil,
          :pageNumberMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :recipientId => String.t() | nil,
          :recipientIdGuid => String.t() | nil,
          :recipientIdGuidMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :recipientIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :smartContractInformation => DocuSign.Model.SmartContractInformation.t() | nil,
          :source => String.t() | nil,
          :status => String.t() | nil,
          :statusMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tabGroupLabels => [String.t()] | nil,
          :tabGroupLabelsMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tabId => String.t() | nil,
          :tabIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tabLabel => String.t() | nil,
          :tabLabelMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tabOrder => String.t() | nil,
          :tabOrderMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tabType => String.t() | nil,
          :tabTypeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :templateLocked => String.t() | nil,
          :templateLockedMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :templateRequired => String.t() | nil,
          :templateRequiredMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tooltip => String.t() | nil,
          :toolTipMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :underline => String.t() | nil,
          :underlineMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :warningDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :width => String.t() | nil,
          :widthMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :xPosition => String.t() | nil,
          :xPositionMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :yPosition => String.t() | nil,
          :yPositionMetadata => DocuSign.Model.PropertyMetadata.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :anchorAllowWhiteSpaceInCharactersMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(
      :anchorCaseSensitiveMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(
      :anchorHorizontalAlignmentMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(
      :anchorIgnoreIfNotPresentMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(
      :anchorMatchWholeWordMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:anchorStringMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :anchorTabProcessorVersionMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:anchorUnitsMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:anchorXOffsetMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:anchorYOffsetMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:boldMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:buttonTextMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:captionMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :conditionalParentLabelMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(
      :conditionalParentValueMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:customTabIdMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:declineReasonMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:documentIdMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:fontColorMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:fontMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:fontSizeMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:formOrderMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:formPageLabelMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:formPageNumberMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:heightMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:italicMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:localePolicy, :struct, DocuSign.Model.LocalePolicyTab)
    |> Deserializer.deserialize(:mergeField, :struct, DocuSign.Model.MergeField)
    |> Deserializer.deserialize(:pageNumberMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :recipientIdGuidMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:recipientIdMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :smartContractInformation,
      :struct,
      DocuSign.Model.SmartContractInformation
    )
    |> Deserializer.deserialize(:statusMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:tabGroupLabelsMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:tabIdMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:tabLabelMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:tabOrderMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:tabTypeMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:templateLockedMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :templateRequiredMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:toolTipMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:underlineMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:warningDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:widthMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:xPositionMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:yPositionMetadata, :struct, DocuSign.Model.PropertyMetadata)
  end
end
