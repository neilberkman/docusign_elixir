# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BrandResources do
  @moduledoc """
  Information about the resource files that the brand uses for the email, signing, sending, and captive (embedded) signing experiences.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.UserInfo

  @derive Jason.Encoder
  defstruct [
    :createdByUserInfo,
    :createdDate,
    :dataNotSavedNotInMaster,
    :modifiedByUserInfo,
    :modifiedDate,
    :modifiedTemplates,
    :resourcesContentType,
    :resourcesContentUri
  ]

  @type t :: %__MODULE__{
          :createdByUserInfo => UserInfo.t() | nil,
          :createdDate => String.t() | nil,
          :dataNotSavedNotInMaster => [String.t()] | nil,
          :modifiedByUserInfo => UserInfo.t() | nil,
          :modifiedDate => String.t() | nil,
          :modifiedTemplates => [String.t()] | nil,
          :resourcesContentType => String.t() | nil,
          :resourcesContentUri => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:createdByUserInfo, :struct, UserInfo)
    |> Deserializer.deserialize(:modifiedByUserInfo, :struct, UserInfo)
  end
end
