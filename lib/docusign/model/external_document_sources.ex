# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ExternalDocumentSources do
  @moduledoc """
  A complex object specifying the external document sources.
  """

  @derive Jason.Encoder
  defstruct [
    :boxnetEnabled,
    :boxnetMetadata,
    :dropboxEnabled,
    :dropboxMetadata,
    :googleDriveEnabled,
    :googleDriveMetadata,
    :oneDriveEnabled,
    :oneDriveMetadata,
    :salesforceEnabled,
    :salesforceMetadata
  ]

  @type t :: %__MODULE__{
          :boxnetEnabled => String.t() | nil,
          :boxnetMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :dropboxEnabled => String.t() | nil,
          :dropboxMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :googleDriveEnabled => String.t() | nil,
          :googleDriveMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :oneDriveEnabled => String.t() | nil,
          :oneDriveMetadata => DocuSign.Model.SettingsMetadata.t() | nil,
          :salesforceEnabled => String.t() | nil,
          :salesforceMetadata => DocuSign.Model.SettingsMetadata.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:boxnetMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:dropboxMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:googleDriveMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:oneDriveMetadata, :struct, DocuSign.Model.SettingsMetadata)
    |> Deserializer.deserialize(:salesforceMetadata, :struct, DocuSign.Model.SettingsMetadata)
  end
end
