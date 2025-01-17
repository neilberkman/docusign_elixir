# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.LinkedExternalPrimaryAccount do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :accountName,
    :configurationId,
    :email,
    :linkId,
    :pdfFieldHandlingOption,
    :recipientAuthRequirements,
    :status,
    :userId
  ]

  @type t :: %__MODULE__{
          :accountName => String.t() | nil,
          :configurationId => String.t() | nil,
          :email => String.t() | nil,
          :linkId => String.t() | nil,
          :pdfFieldHandlingOption => String.t() | nil,
          :recipientAuthRequirements =>
            DocuSign.Model.ExternalPrimaryAccountRecipientAuthRequirements.t() | nil,
          :status => String.t() | nil,
          :userId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.LinkedExternalPrimaryAccount do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :recipientAuthRequirements,
      :struct,
      DocuSign.Model.ExternalPrimaryAccountRecipientAuthRequirements,
      options
    )
  end
end
