# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientNamesResponse do
  @moduledoc """
  This response object contains a list of recipients.
  """

  @derive Jason.Encoder
  defstruct [
    :multipleUsers,
    :recipientNames,
    :reservedRecipientEmail
  ]

  @type t :: %__MODULE__{
          :multipleUsers => String.t() | nil,
          :recipientNames => [String.t()] | nil,
          :reservedRecipientEmail => String.t() | nil
        }

  def decode(value) do
    value
  end
end
