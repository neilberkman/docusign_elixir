# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Radio do
  @moduledoc """
  One of the selectable radio buttons in the `radios` property of a [`radioGroup`](/docs/esign-rest-api/reference/envelopes/enveloperecipienttabs/) tab. 
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
    :errorDetails,
    :font,
    :fontColor,
    :fontColorMetadata,
    :fontMetadata,
    :fontSize,
    :fontSizeMetadata,
    :italic,
    :italicMetadata,
    :locked,
    :lockedMetadata,
    :mergeFieldXml,
    :pageNumber,
    :pageNumberMetadata,
    :required,
    :requiredMetadata,
    :selected,
    :selectedMetadata,
    :status,
    :statusMetadata,
    :tabId,
    :tabIdMetadata,
    :tabOrder,
    :tabOrderMetadata,
    :underline,
    :underlineMetadata,
    :value,
    :valueMetadata,
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
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :font => String.t() | nil,
          :fontColor => String.t() | nil,
          :fontColorMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :fontMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :fontSize => String.t() | nil,
          :fontSizeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :italic => String.t() | nil,
          :italicMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :locked => String.t() | nil,
          :lockedMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :mergeFieldXml => String.t() | nil,
          :pageNumber => String.t() | nil,
          :pageNumberMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :required => String.t() | nil,
          :requiredMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :selected => String.t() | nil,
          :selectedMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :status => String.t() | nil,
          :statusMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tabId => String.t() | nil,
          :tabIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tabOrder => String.t() | nil,
          :tabOrderMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :underline => String.t() | nil,
          :underlineMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :value => String.t() | nil,
          :valueMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
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
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:fontColorMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:fontMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:fontSizeMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:italicMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:lockedMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:pageNumberMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:requiredMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:selectedMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:statusMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:tabIdMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:tabOrderMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:underlineMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:valueMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:xPositionMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:yPositionMetadata, :struct, DocuSign.Model.PropertyMetadata)
  end
end
