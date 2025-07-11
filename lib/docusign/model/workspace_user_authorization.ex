# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.WorkspaceUserAuthorization do
  @moduledoc """
  Provides properties that describe user authorization to a workspace.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.ErrorDetails
  alias DocuSign.Model.WorkspaceUser

  @derive Jason.Encoder
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
          :errorDetails => ErrorDetails.t() | nil,
          :modified => String.t() | nil,
          :modifiedById => String.t() | nil,
          :workspaceUserId => String.t() | nil,
          :workspaceUserInformation => WorkspaceUser.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, ErrorDetails)
    |> Deserializer.deserialize(:workspaceUserInformation, :struct, WorkspaceUser)
  end
end
