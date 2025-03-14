# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TabsBlob do
  @moduledoc """
  Reserved for Docusign.
  """

  @derive Jason.Encoder
  defstruct [
    :allowTabOrder,
    :allowTabOrderMetadata,
    :approveDeclineTabsEnabled,
    :approveDeclineTabsMetadata,
    :calculatedFieldsEnabled,
    :calculatedFieldsMetadata,
    :checkboxTabsEnabled,
    :checkBoxTabsMetadata,
    :dataFieldRegexEnabled,
    :dataFieldRegexMetadata,
    :dataFieldSizeEnabled,
    :dataFieldSizeMetadata,
    :drawTabsEnabled,
    :drawTabsMetadata,
    :enableTabAgreementDetails,
    :enableTabAgreementDetailsMetadata,
    :firstLastEmailTabsEnabled,
    :firstLastEmailTabsMetadata,
    :listTabsEnabled,
    :listTabsMetadata,
    :noteTabsEnabled,
    :noteTabsMetadata,
    :numericalTabsEnabled,
    :numericalTabsMetadata,
    :prefillTabsEnabled,
    :prefillTabsMetadata,
    :radioTabsEnabled,
    :radioTabsMetadata,
    :savingCustomTabsEnabled,
    :savingCustomTabsMetadata,
    :senderToChangeTabAssignmentsEnabled,
    :senderToChangeTabAssignmentsMetadata,
    :sharedCustomTabsEnabled,
    :sharedCustomTabsMetadata,
    :tabDataLabelEnabled,
    :tabDataLabelMetadata,
    :tabLocationEnabled,
    :tabLocationMetadata,
    :tabLockingEnabled,
    :tabLockingMetadata,
    :tabScaleEnabled,
    :tabScaleMetadata,
    :tabTextFormattingEnabled,
    :tabTextFormattingMetadata,
    :textTabsEnabled,
    :textTabsMetadata
  ]

  @type t :: %__MODULE__{
          :allowTabOrder => String.t() | nil,
          :allowTabOrderMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :approveDeclineTabsEnabled => String.t() | nil,
          :approveDeclineTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :calculatedFieldsEnabled => String.t() | nil,
          :calculatedFieldsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :checkboxTabsEnabled => String.t() | nil,
          :checkBoxTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :dataFieldRegexEnabled => String.t() | nil,
          :dataFieldRegexMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :dataFieldSizeEnabled => String.t() | nil,
          :dataFieldSizeMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :drawTabsEnabled => String.t() | nil,
          :drawTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :enableTabAgreementDetails => String.t() | nil,
          :enableTabAgreementDetailsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :firstLastEmailTabsEnabled => String.t() | nil,
          :firstLastEmailTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :listTabsEnabled => String.t() | nil,
          :listTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :noteTabsEnabled => String.t() | nil,
          :noteTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :numericalTabsEnabled => String.t() | nil,
          :numericalTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :prefillTabsEnabled => String.t() | nil,
          :prefillTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :radioTabsEnabled => String.t() | nil,
          :radioTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :savingCustomTabsEnabled => String.t() | nil,
          :savingCustomTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :senderToChangeTabAssignmentsEnabled => String.t() | nil,
          :senderToChangeTabAssignmentsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :sharedCustomTabsEnabled => String.t() | nil,
          :sharedCustomTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :tabDataLabelEnabled => String.t() | nil,
          :tabDataLabelMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :tabLocationEnabled => String.t() | nil,
          :tabLocationMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :tabLockingEnabled => String.t() | nil,
          :tabLockingMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :tabScaleEnabled => String.t() | nil,
          :tabScaleMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :tabTextFormattingEnabled => String.t() | nil,
          :tabTextFormattingMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :textTabsEnabled => String.t() | nil,
          :textTabsMetadata => DocuSign.Model.SettingsMetadata.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:allowTabOrderMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(
      :approveDeclineTabsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata
    )
    |> Deserializer.deserialize(
      :calculatedFieldsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata
    )
    |> Deserializer.deserialize(:checkBoxTabsMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:dataFieldRegexMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:dataFieldSizeMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:drawTabsMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(
      :enableTabAgreementDetailsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata
    )
    |> Deserializer.deserialize(
      :firstLastEmailTabsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata
    )
    |> Deserializer.deserialize(:listTabsMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:noteTabsMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:numericalTabsMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:prefillTabsMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:radioTabsMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(
      :savingCustomTabsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata
    )
    |> Deserializer.deserialize(
      :senderToChangeTabAssignmentsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata
    )
    |> Deserializer.deserialize(
      :sharedCustomTabsMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata
    )
    |> Deserializer.deserialize(:tabDataLabelMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:tabLocationMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:tabLockingMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:tabScaleMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(
      :tabTextFormattingMetadata,
      :struct,
      DocuSign.Model.SettingsMetadata
    )
    |> Deserializer.deserialize(:textTabsMetadata, :struct, DocuSign.Model.SettingsMetadata)
  end
end
