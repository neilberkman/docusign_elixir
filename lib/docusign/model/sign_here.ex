# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.SignHere do
  @moduledoc """
  A tab that allows the recipient to sign a document. May be optional. 
  """

  @derive [Poison.Encoder]
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
    :caption,
    :captionMetadata,
    :conditionalParentLabel,
    :conditionalParentLabelMetadata,
    :conditionalParentValue,
    :conditionalParentValueMetadata,
    :customTabId,
    :customTabIdMetadata,
    :documentId,
    :documentIdMetadata,
    :errorDetails,
    :formOrder,
    :formOrderMetadata,
    :formPageLabel,
    :formPageLabelMetadata,
    :formPageNumber,
    :formPageNumberMetadata,
    :handDrawRequired,
    :height,
    :heightMetadata,
    :isSealSignTab,
    :mergeField,
    :mergeFieldXml,
    :name,
    :nameMetadata,
    :optional,
    :optionalMetadata,
    :pageNumber,
    :pageNumberMetadata,
    :recipientId,
    :recipientIdGuid,
    :recipientIdGuidMetadata,
    :recipientIdMetadata,
    :scaleValue,
    :scaleValueMetadata,
    :smartContractInformation,
    :source,
    :stamp,
    :stampType,
    :stampTypeMetadata,
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
          :caption => String.t() | nil,
          :captionMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :conditionalParentLabel => String.t() | nil,
          :conditionalParentLabelMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :conditionalParentValue => String.t() | nil,
          :conditionalParentValueMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :customTabId => String.t() | nil,
          :customTabIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :documentId => String.t() | nil,
          :documentIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :formOrder => String.t() | nil,
          :formOrderMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :formPageLabel => String.t() | nil,
          :formPageLabelMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :formPageNumber => String.t() | nil,
          :formPageNumberMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :handDrawRequired => String.t() | nil,
          :height => String.t() | nil,
          :heightMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :isSealSignTab => String.t() | nil,
          :mergeField => DocuSign.Model.MergeField.t() | nil,
          :mergeFieldXml => String.t() | nil,
          :name => String.t() | nil,
          :nameMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :optional => String.t() | nil,
          :optionalMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :pageNumber => String.t() | nil,
          :pageNumberMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :recipientId => String.t() | nil,
          :recipientIdGuid => String.t() | nil,
          :recipientIdGuidMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :recipientIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :scaleValue => String.t() | nil,
          :scaleValueMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :smartContractInformation => DocuSign.Model.SmartContractInformation.t() | nil,
          :source => String.t() | nil,
          :stamp => DocuSign.Model.Stamp.t() | nil,
          :stampType => String.t() | nil,
          :stampTypeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
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
          :width => String.t() | nil,
          :widthMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :xPosition => String.t() | nil,
          :xPositionMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :yPosition => String.t() | nil,
          :yPositionMetadata => DocuSign.Model.PropertyMetadata.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.SignHere do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :anchorAllowWhiteSpaceInCharactersMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
    |> deserialize(
      :anchorCaseSensitiveMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
    |> deserialize(
      :anchorHorizontalAlignmentMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
    |> deserialize(
      :anchorIgnoreIfNotPresentMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
    |> deserialize(
      :anchorMatchWholeWordMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
    |> deserialize(:anchorStringMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(
      :anchorTabProcessorVersionMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
    |> deserialize(:anchorUnitsMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:anchorXOffsetMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:anchorYOffsetMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:captionMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(
      :conditionalParentLabelMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
    |> deserialize(
      :conditionalParentValueMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
    |> deserialize(:customTabIdMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:documentIdMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
    |> deserialize(:formOrderMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:formPageLabelMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:formPageNumberMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:heightMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:mergeField, :struct, DocuSign.Model.MergeField, options)
    |> deserialize(:nameMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:optionalMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:pageNumberMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:recipientIdGuidMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:recipientIdMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:scaleValueMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(
      :smartContractInformation,
      :struct,
      DocuSign.Model.SmartContractInformation,
      options
    )
    |> deserialize(:stamp, :struct, DocuSign.Model.Stamp, options)
    |> deserialize(:stampTypeMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:statusMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabGroupLabelsMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabIdMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabLabelMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabOrderMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabTypeMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:templateLockedMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:templateRequiredMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:toolTipMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:widthMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:xPositionMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:yPositionMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
  end
end
