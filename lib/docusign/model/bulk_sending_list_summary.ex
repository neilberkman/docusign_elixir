# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkSendingListSummary do
  @moduledoc """
  This object contains basic information about a bulk send list.
  """

  @derive [Poison.Encoder]
  defstruct [
    :bulkSendListId,
    :createdByUser,
    :createdDate,
    :name
  ]

  @type t :: %__MODULE__{
          :bulkSendListId => String.t() | nil,
          :createdByUser => String.t() | nil,
          :createdDate => String.t() | nil,
          :name => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BulkSendingListSummary do
  def decode(value, _options) do
    value
  end
end