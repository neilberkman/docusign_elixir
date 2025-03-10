# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RadioGroup do
  @moduledoc """
  This group tab is used to place radio buttons on a document. The `radios` property contains a list of [`radio`](/docs/esign-rest-api/reference/envelopes/enveloperecipienttabs/) objects  associated with the group. Only one radio button can be selected in a group. 
  """

  @derive Jason.Encoder
  defstruct [
    :conditionalParentLabel,
    :conditionalParentLabelMetadata,
    :conditionalParentValue,
    :conditionalParentValueMetadata,
    :documentId,
    :documentIdMetadata,
    :groupName,
    :groupNameMetadata,
    :originalValue,
    :originalValueMetadata,
    :radios,
    :recipientId,
    :recipientIdGuid,
    :recipientIdGuidMetadata,
    :recipientIdMetadata,
    :requireAll,
    :requireAllMetadata,
    :requireInitialOnSharedChange,
    :requireInitialOnSharedChangeMetadata,
    :shared,
    :sharedMetadata,
    :shareToRecipients,
    :shareToRecipientsMetadata,
    :tabType,
    :tabTypeMetadata,
    :templateLocked,
    :templateLockedMetadata,
    :templateRequired,
    :templateRequiredMetadata,
    :tooltip,
    :tooltipMetadata,
    :value,
    :valueMetadata
  ]

  @type t :: %__MODULE__{
          :conditionalParentLabel => String.t() | nil,
          :conditionalParentLabelMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :conditionalParentValue => String.t() | nil,
          :conditionalParentValueMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :documentId => String.t() | nil,
          :documentIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :groupName => String.t() | nil,
          :groupNameMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :originalValue => String.t() | nil,
          :originalValueMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :radios => [DocuSign.Model.Radio.t()] | nil,
          :recipientId => String.t() | nil,
          :recipientIdGuid => String.t() | nil,
          :recipientIdGuidMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :recipientIdMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :requireAll => String.t() | nil,
          :requireAllMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :requireInitialOnSharedChange => String.t() | nil,
          :requireInitialOnSharedChangeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :shared => String.t() | nil,
          :sharedMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :shareToRecipients => String.t() | nil,
          :shareToRecipientsMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tabType => String.t() | nil,
          :tabTypeMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :templateLocked => String.t() | nil,
          :templateLockedMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :templateRequired => String.t() | nil,
          :templateRequiredMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :tooltip => String.t() | nil,
          :tooltipMetadata => DocuSign.Model.PropertyMetadata.t() | nil,
          :value => String.t() | nil,
          :valueMetadata => DocuSign.Model.PropertyMetadata.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
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
    |> Deserializer.deserialize(:documentIdMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:groupNameMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:originalValueMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:radios, :list, DocuSign.Model.Radio)
    |> Deserializer.deserialize(
      :recipientIdGuidMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:recipientIdMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:requireAllMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :requireInitialOnSharedChangeMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:sharedMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :shareToRecipientsMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:tabTypeMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:templateLockedMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(
      :templateRequiredMetadata,
      :struct,
      DocuSign.Model.PropertyMetadata
    )
    |> Deserializer.deserialize(:tooltipMetadata, :struct, DocuSign.Model.PropertyMetadata)
    |> Deserializer.deserialize(:valueMetadata, :struct, DocuSign.Model.PropertyMetadata)
  end
end
