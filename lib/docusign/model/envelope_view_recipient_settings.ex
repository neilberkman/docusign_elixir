# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeViewRecipientSettings do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :showBulkSend,
    :showContactsList,
    :showEditMessage,
    :showEditRecipients
  ]

  @type t :: %__MODULE__{
          :showBulkSend => String.t() | nil,
          :showContactsList => String.t() | nil,
          :showEditMessage => String.t() | nil,
          :showEditRecipients => String.t() | nil
        }

  def decode(value) do
    value
  end
end
