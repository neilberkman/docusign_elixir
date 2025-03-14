# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.FormulaTab do
  @moduledoc """
  The value of a formula tab is calculated from the values of other number or date tabs in the document. When the recipient completes the underlying fields, the formula tab calculates and displays the result.  The `formula` property of the tab contains the references to the underlying tabs. See [Calculated Fields][calculatedfields] in the Docusign Support Center to learn more about formulas.  If a formula tab contains a `paymentDetails` property, the tab is considered a payment item. See [Requesting Payments Along with Signatures][paymentguide] in the Docusign Support Center to learn more about payments.  [calculatedfields]: https://support.docusign.com/s/document-item?bundleId=gbo1643332197980&topicId=crs1578456361259.html [paymentguide]:     https://support.docusign.com/s/document-item?bundleId=juu1573854950452&topicId=fyw1573854935374.html 
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
    :formula,
    :formulaMetadata,
    :height,
    :heightMetadata,
    :hidden,
    :hiddenMetadata,
    :isPaymentAmountMetadata,
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
    :paymentDetails,
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
    :roundDecimalPlaces,
    :roundDecimalPlacesMetadata,
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
          :formula => String.t() | nil,
          :formulaMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :height => String.t() | nil,
          :heightMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :hidden => String.t() | nil,
          :hiddenMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :isPaymentAmountMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
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
          :paymentDetails => DocuSign.Model.PaymentDetails.t() | nil,
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
          :roundDecimalPlaces => String.t() | nil,
          :roundDecimalPlacesMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
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
    |> Deserializer.deserialize(:captionMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :concealValueOnDocumentMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
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
    |> Deserializer.deserialize(
      :disableAutoSizeMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:documentIdMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:fontColorMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:fontMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:fontSizeMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:formOrderMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:formPageLabelMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:formPageNumberMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:formulaMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:heightMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:hiddenMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :isPaymentAmountMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:italicMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:localePolicy, :struct, DocuSign.Model.LocalePolicyTab)
    |> Deserializer.deserialize(:lockedMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:maxLengthMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:mergeField, :struct, DocuSign.Model.MergeField)
    |> Deserializer.deserialize(:nameMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:originalValueMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:pageNumberMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:paymentDetails, :struct, DocuSign.Model.PaymentDetails)
    |> Deserializer.deserialize(
      :recipientIdGuidMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:recipientIdMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:requireAllMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:requiredMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :requireInitialOnSharedChangeMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(
      :roundDecimalPlacesMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:senderRequiredMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:sharedMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :shareToRecipientsMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
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
    |> Deserializer.deserialize(
      :validationMessageMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(
      :validationPatternMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:valueMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:warningDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:widthMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:xPositionMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:yPositionMetadata, :struct, DocuSign.Model.PropertyMetadata)
  end
end
