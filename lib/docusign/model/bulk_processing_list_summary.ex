# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkProcessingListSummary do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :bulkProcessListId,
    :createdByUser,
    :createdDate,
    :name
  ]

  @type t :: %__MODULE__{
          :bulkProcessListId => String.t() | nil,
          :createdByUser => String.t() | nil,
          :createdDate => String.t() | nil,
          :name => String.t() | nil
        }

  def decode(value) do
    value
  end
end
