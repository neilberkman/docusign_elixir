# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.WorkspaceUserAuthorization do
  @moduledoc """
  Provides properties that describe user authorization to a workspace.
  """

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
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :modified => String.t() | nil,
          :modifiedById => String.t() | nil,
          :workspaceUserId => String.t() | nil,
          :workspaceUserInformation => DocuSign.Model.WorkspaceUser.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
    |> Deserializer.deserialize(:workspaceUserInformation, :struct, DocuSign.Model.WorkspaceUser)
  end
end
