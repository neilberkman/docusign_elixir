# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DocuSignDate do
  @moduledoc """
  A tab that allows the recipient to enter a date. Date tabs are one-line fields that allow date information to be entered in any format. The tooltip for this tab recommends entering the date as MM/DD/YYYY, but this is not enforced. The format entered by the signer is retained. If you need a particular date format enforced, DocuSign recommends using a Text tab with a validation pattern and a validation message to enforce the format.
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
    :bold,
    :boldMetadata,
    :caption,
    :captionMetadata,
    :concealValueOnDocument,
    :concealValueOnDocumentMetadata,
    :conditionalParentLabel,
    :conditionalParentLabelMetadata,
    :conditionalParentValue,
    :conditionalParentValueMetadata,
    :customTabId,
    :customTabIdMetadata,
    :disableAutoSize,
    :disableAutoSizeMetadata,
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
    :locked,
    :lockedMetadata,
    :maxLength,
    :maxLengthMetadata,
    :mergeField,
    :mergeFieldXml,
    :name,
    :nameMetadata,
    :originalValue,
    :originalValueMetadata,
    :pageNumber,
    :pageNumberMetadata,
    :recipientId,
    :recipientIdGuid,
    :recipientIdGuidMetadata,
    :recipientIdMetadata,
    :requireAll,
    :requireAllMetadata,
    :required,
    :requiredMetadata,
    :requireInitialOnSharedChange,
    :requireInitialOnSharedChangeMetadata,
    :senderRequired,
    :senderRequiredMetadata,
    :shared,
    :sharedMetadata,
    :shareToRecipients,
    :shareToRecipientsMetadata,
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
    :validationMessage,
    :validationMessageMetadata,
    :validationPattern,
    :validationPatternMetadata,
    :value,
    :valueMetadata,
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
          :caption => String.t() | nil,
          :captionMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :concealValueOnDocument => String.t() | nil,
          :concealValueOnDocumentMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :conditionalParentLabel => String.t() | nil,
          :conditionalParentLabelMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :conditionalParentValue => String.t() | nil,
          :conditionalParentValueMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :customTabId => String.t() | nil,
          :customTabIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :disableAutoSize => String.t() | nil,
          :disableAutoSizeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
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
          :locked => String.t() | nil,
          :lockedMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :maxLength => String.t() | nil,
          :maxLengthMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :mergeField => DocuSign.Model.MergeField.t() | nil,
          :mergeFieldXml => String.t() | nil,
          :name => String.t() | nil,
          :nameMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :originalValue => String.t() | nil,
          :originalValueMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :pageNumber => String.t() | nil,
          :pageNumberMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :recipientId => String.t() | nil,
          :recipientIdGuid => String.t() | nil,
          :recipientIdGuidMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :recipientIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :requireAll => String.t() | nil,
          :requireAllMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :required => String.t() | nil,
          :requiredMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :requireInitialOnSharedChange => String.t() | nil,
          :requireInitialOnSharedChangeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :senderRequired => String.t() | nil,
          :senderRequiredMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :shared => String.t() | nil,
          :sharedMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :shareToRecipients => String.t() | nil,
          :shareToRecipientsMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
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
          :validationMessage => String.t() | nil,
          :validationMessageMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :validationPattern => String.t() | nil,
          :validationPatternMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :value => String.t() | nil,
          :valueMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :width => String.t() | nil,
          :widthMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :xPosition => String.t() | nil,
          :xPositionMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :yPosition => String.t() | nil,
          :yPositionMetadata => DocuSign.Model.PropertyMetadata.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.DocuSignDate do
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
    |> deserialize(:boldMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:captionMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(
      :concealValueOnDocumentMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
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
    |> deserialize(:disableAutoSizeMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:documentIdMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
    |> deserialize(:fontColorMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:fontMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:fontSizeMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:formOrderMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:formPageLabelMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:formPageNumberMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:heightMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:italicMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:localePolicy, :struct, DocuSign.Model.LocalePolicyTab, options)
    |> deserialize(:lockedMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:maxLengthMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:mergeField, :struct, DocuSign.Model.MergeField, options)
    |> deserialize(:nameMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:originalValueMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:pageNumberMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:recipientIdGuidMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:recipientIdMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:requireAllMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:requiredMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(
      :requireInitialOnSharedChangeMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata,
      options
    )
    |> deserialize(:senderRequiredMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:sharedMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:shareToRecipientsMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(
      :smartContractInformation,
      :struct,
      DocuSign.Model.SmartContractInformation,
      options
    )
    |> deserialize(:statusMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabGroupLabelsMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabIdMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabLabelMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabOrderMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:tabTypeMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:templateLockedMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:templateRequiredMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:toolTipMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:underlineMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:validationMessageMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:validationPatternMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:valueMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:widthMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:xPositionMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
    |> deserialize(:yPositionMetadata, :struct, DocuSign.Model.PropertyMetadata, options)
  end
end
