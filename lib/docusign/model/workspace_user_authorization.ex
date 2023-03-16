# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.WorkspaceUserAuthorization do
  @moduledoc """
  Provides properties that describe user authorization to a workspace.
  """

  @derive [Poison.Encoder]
  defstruct [
    :canDelete,
    :canMove,
    :canTransact,
    :canView,
    :created,
    :createdById,
    :errorDetails,
    :modified,
    :modifiedById,
    :workspaceUserId,
    :workspaceUserInformation
  ]

  @type t :: %__MODULE__{
          :canDelete => String.t() | nil,
          :canMove => String.t() | nil,
          :canTransact => String.t() | nil,
          :canView => String.t() | nil,
          :created => String.t() | nil,
          :createdById => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :modified => String.t() | nil,
          :modifiedById => String.t() | nil,
          :workspaceUserId => String.t() | nil,
          :workspaceUserInformation => DocuSign.Model.WorkspaceUser.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.WorkspaceUserAuthorization do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
    |> deserialize(:workspaceUserInformation, :struct, DocuSign.Model.WorkspaceUser, options)
  end
end
