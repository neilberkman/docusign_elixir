# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.SigningGroups do
  @moduledoc """
  Signing groups
  """

  @derive Jason.Encoder
  defstruct [
    :created,
    :createdBy,
    :errorDetails,
    :groupEmail,
    :groupName,
    :groupType,
    :modified,
    :modifiedBy,
    :signingGroupId,
    :users
  ]

  @type t :: %__MODULE__{
          :created => String.t() | nil,
          :createdBy => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :groupEmail => String.t() | nil,
          :groupName => String.t() | nil,
          :groupType => String.t() | nil,
          :modified => String.t() | nil,
          :modifiedBy => String.t() | nil,
          :signingGroupId => String.t() | nil,
          :users => [DocuSign.Model.SigningGroupUser.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:users, :list, DocuSign.Model.SigningGroupUser)
  end
end
