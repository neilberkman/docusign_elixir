# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeTransferRuleRequest do
  @moduledoc """
  This object contains details about the envelope transfer rule that you want to create.
  """

  @derive [Poison.Encoder]
  defstruct [
    :carbonCopyOriginalOwner,
    :enabled,
    :envelopeTransferRuleId,
    :eventType,
    :fromGroups,
    :fromUsers,
    :modifiedDate,
    :modifiedUser,
    :toFolder,
    :toUser
  ]

  @type t :: %__MODULE__{
          :carbonCopyOriginalOwner => String.t() | nil,
          :enabled => String.t() | nil,
          :envelopeTransferRuleId => String.t() | nil,
          :eventType => String.t() | nil,
          :fromGroups => [DocuSign.Model.Group.t()] | nil,
          :fromUsers => [DocuSign.Model.UserInformation.t()] | nil,
          :modifiedDate => String.t() | nil,
          :modifiedUser => DocuSign.Model.UserInformation.t() | nil,
          :toFolder => DocuSign.Model.Folder.t() | nil,
          :toUser => DocuSign.Model.UserInformation.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeTransferRuleRequest do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:fromGroups, :list, DocuSign.Model.Group, options)
    |> deserialize(:fromUsers, :list, DocuSign.Model.UserInformation, options)
    |> deserialize(:modifiedUser, :struct, DocuSign.Model.UserInformation, options)
    |> deserialize(:toFolder, :struct, DocuSign.Model.Folder, options)
    |> deserialize(:toUser, :struct, DocuSign.Model.UserInformation, options)
  end
end