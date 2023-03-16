# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.FavoriteTemplatesInfo do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :errorDetails,
    :favoriteTemplates,
    :templatesUpdatedCount
  ]

  @type t :: %__MODULE__{
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :favoriteTemplates => [DocuSign.Model.FavoriteTemplatesContentItem.t()] | nil,
          :templatesUpdatedCount => integer() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.FavoriteTemplatesInfo do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
    |> deserialize(
      :favoriteTemplates,
      :list,
      DocuSign.Model.FavoriteTemplatesContentItem,
      options
    )
  end
end
