# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TemplateSharedItem do
  @moduledoc """
  Information about shared templates.
  """

  @derive Jason.Encoder
  defstruct [
    :errorDetails,
    :owner,
    :password,
    :shared,
    :sharedGroups,
    :sharedUsers,
    :templateId,
    :templateName
  ]

  @type t :: %__MODULE__{
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :owner => DocuSign.Model.UserInfo.t() | nil,
          :password => String.t() | nil,
          :shared => String.t() | nil,
          :sharedGroups => [DocuSign.Model.MemberGroupSharedItem.t()] | nil,
          :sharedUsers => [DocuSign.Model.UserSharedItem.t()] | nil,
          :templateId => String.t() | nil,
          :templateName => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:owner, :struct, DocuSign.Model.UserInfo)
    |> Deserializer.deserialize(:sharedGroups, :list, DocuSign.Model.MemberGroupSharedItem)
    |> Deserializer.deserialize(:sharedUsers, :list, DocuSign.Model.UserSharedItem)
  end
end
