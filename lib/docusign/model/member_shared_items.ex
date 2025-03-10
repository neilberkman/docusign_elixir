# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.MemberSharedItems do
  @moduledoc """
  Information about shared items.
  """

  @derive Jason.Encoder
  defstruct [
    :envelopes,
    :errorDetails,
    :folders,
    :templates,
    :user
  ]

  @type t :: %__MODULE__{
          :envelopes => [DocuSign.Model.SharedItem.t()] | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :folders => [DocuSign.Model.FolderSharedItem.t()] | nil,
          :templates => [DocuSign.Model.TemplateSharedItem.t()] | nil,
          :user => DocuSign.Model.UserInfo.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:envelopes, :list, DocuSign.Model.SharedItem)
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:folders, :list, DocuSign.Model.FolderSharedItem)
    |> Deserializer.deserialize(:templates, :list, DocuSign.Model.TemplateSharedItem)
    |> Deserializer.deserialize(:user, :struct, DocuSign.Model.UserInfo)
  end
end
