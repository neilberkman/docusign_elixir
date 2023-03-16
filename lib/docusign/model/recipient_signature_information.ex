# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientSignatureInformation do
  @moduledoc """
  Allows the sender to pre-specify the signature name, signature initials and signature font used in the signature stamp for the recipient.  Used only with recipient types In Person Signers and Signers.
  """

  @derive [Poison.Encoder]
  defstruct [
    :fontStyle,
    :signatureInitials,
    :signatureName
  ]

  @type t :: %__MODULE__{
          :fontStyle => String.t() | nil,
          :signatureInitials => String.t() | nil,
          :signatureName => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.RecipientSignatureInformation do
  def decode(value, _options) do
    value
  end
end
