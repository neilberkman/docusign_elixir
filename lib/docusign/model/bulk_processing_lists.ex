# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkProcessingLists do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :bulkProcessListIds
  ]

  @type t :: %__MODULE__{
          :bulkProcessListIds => [String.t()] | nil
        }

  def decode(value) do
    value
  end
end
