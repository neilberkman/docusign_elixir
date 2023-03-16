# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountSignatureDefinition do
  @moduledoc """

  """

  @derive [Poison.Encoder]
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
end

defimpl Poison.Decoder, for: DocuSign.Model.AccountSignatureDefinition do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:dateStampProperties, :struct, DocuSign.Model.DateStampProperties, options)
    |> deserialize(:signatureGroups, :list, DocuSign.Model.SignatureGroupDef, options)
    |> deserialize(:signatureUsers, :list, DocuSign.Model.SignatureUserDef, options)
  end
end
