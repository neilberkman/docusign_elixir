# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountSignatureDefinition do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :dateStampProperties,
    :disallowUserResizeStamp,
    :externalID,
    :imageType,
    :isDefault,
    :nrdsId,
    :nrdsLastName,
    :phoneticName,
    :signatureFont,
    :signatureGroups,
    :signatureId,
    :signatureInitials,
    :signatureName,
    :signatureType,
    :signatureUsers,
    :stampFormat,
    :stampSizeMM
  ]

  @type t :: %__MODULE__{
          :dateStampProperties => DocuSign.Model.DateStampProperties.t() | nil,
          :disallowUserResizeStamp => String.t() | nil,
          :externalID => String.t() | nil,
          :imageType => String.t() | nil,
          :isDefault => String.t() | nil,
          :nrdsId => String.t() | nil,
          :nrdsLastName => String.t() | nil,
          :phoneticName => String.t() | nil,
          :signatureFont => String.t() | nil,
          :signatureGroups => [DocuSign.Model.SignatureGroupDef.t()] | nil,
          :signatureId => String.t() | nil,
          :signatureInitials => String.t() | nil,
          :signatureName => String.t() | nil,
          :signatureType => String.t() | nil,
          :signatureUsers => [DocuSign.Model.SignatureUserDef.t()] | nil,
          :stampFormat => String.t() | nil,
          :stampSizeMM => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:dateStampProperties, :struct, DocuSign.Model.DateStampProperties)
    |> Deserializer.deserialize(:signatureGroups, :list, DocuSign.Model.SignatureGroupDef)
    |> Deserializer.deserialize(:signatureUsers, :list, DocuSign.Model.SignatureUserDef)
  end
end
