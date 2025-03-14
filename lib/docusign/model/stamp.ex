# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Stamp do
  @moduledoc """

  """

  @derive Jason.Encoder
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
    :lastModifiedDateTime,
    :phoneticName,
    :signatureName,
    :stampFormat,
    :stampImageUri,
    :stampSizeMM,
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
          :lastModifiedDateTime => String.t() | nil,
          :phoneticName => String.t() | nil,
          :signatureName => String.t() | nil,
          :stampFormat => String.t() | nil,
          :stampImageUri => String.t() | nil,
          :stampSizeMM => String.t() | nil,
          :status => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:dateStampProperties, :struct, DocuSign.Model.DateStampProperties)
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
  end
end
