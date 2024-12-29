# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountSignature do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :adoptedDateTime,
    :createdDateTime,
    :customField,
    :dateStampProperties,
    :disallowUserResizeStamp,
    :errorDetails,
    :externalID,
    :imageBase64,
    :imageType,
    :initials150ImageId,
    :initialsImageUri,
    :isDefault,
    :lastModifiedDateTime,
    :nrdsId,
    :nrdsLastName,
    :nrdsStatus,
    :phoneticName,
    :signature150ImageId,
    :signatureFont,
    :signatureGroups,
    :signatureId,
    :signatureImageUri,
    :signatureInitials,
    :signatureName,
    :signatureRights,
    :signatureType,
    :signatureUsers,
    :stampFormat,
    :stampImageUri,
    :stampSizeMM,
    :stampType,
    :status
  ]

  @type t :: %__MODULE__{
          :adoptedDateTime => String.t() | nil,
          :createdDateTime => String.t() | nil,
          :customField => String.t() | nil,
          :dateStampProperties => DocuSign.Model.DateStampProperties.t() | nil,
          :disallowUserResizeStamp => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :externalID => String.t() | nil,
          :imageBase64 => String.t() | nil,
          :imageType => String.t() | nil,
          :initials150ImageId => String.t() | nil,
          :initialsImageUri => String.t() | nil,
          :isDefault => String.t() | nil,
          :lastModifiedDateTime => String.t() | nil,
          :nrdsId => String.t() | nil,
          :nrdsLastName => String.t() | nil,
          :nrdsStatus => String.t() | nil,
          :phoneticName => String.t() | nil,
          :signature150ImageId => String.t() | nil,
          :signatureFont => String.t() | nil,
          :signatureGroups => [DocuSign.Model.SignatureGroup.t()] | nil,
          :signatureId => String.t() | nil,
          :signatureImageUri => String.t() | nil,
          :signatureInitials => String.t() | nil,
          :signatureName => String.t() | nil,
          :signatureRights => String.t() | nil,
          :signatureType => String.t() | nil,
          :signatureUsers => [DocuSign.Model.SignatureUser.t()] | nil,
          :stampFormat => String.t() | nil,
          :stampImageUri => String.t() | nil,
          :stampSizeMM => String.t() | nil,
          :stampType => String.t() | nil,
          :status => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.AccountSignature do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:dateStampProperties, :struct, DocuSign.Model.DateStampProperties, options)
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
    |> deserialize(:signatureGroups, :list, DocuSign.Model.SignatureGroup, options)
    |> deserialize(:signatureUsers, :list, DocuSign.Model.SignatureUser, options)
  end
end
