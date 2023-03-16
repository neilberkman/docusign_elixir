# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Contacts do
  @moduledoc """
  The `Contacts` resource enables you to manage the contact in an account's address book.
  """

  @derive [Poison.Encoder]
  defstruct [
    :cloudProvider,
    :cloudProviderContainerId,
    :contactId,
    :contactPhoneNumbers,
    :contactUri,
    :emails,
    :errorDetails,
    :isOwner,
    :name,
    :notaryContactDetails,
    :organization,
    :roomContactType,
    :shared,
    :signingGroup,
    :signingGroupName
  ]

  @type t :: %__MODULE__{
          :cloudProvider => String.t() | nil,
          :cloudProviderContainerId => String.t() | nil,
          :contactId => String.t() | nil,
          :contactPhoneNumbers => [DocuSign.Model.ContactPhoneNumber.t()] | nil,
          :contactUri => String.t() | nil,
          :emails => [String.t()] | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :isOwner => boolean() | nil,
          :name => String.t() | nil,
          :notaryContactDetails => DocuSign.Model.NotaryContactDetails.t() | nil,
          :organization => String.t() | nil,
          :roomContactType => String.t() | nil,
          :shared => String.t() | nil,
          :signingGroup => String.t() | nil,
          :signingGroupName => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.Contacts do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:contactPhoneNumbers, :list, DocuSign.Model.ContactPhoneNumber, options)
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
    |> deserialize(:notaryContactDetails, :struct, DocuSign.Model.NotaryContactDetails, options)
  end
end
