# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientDomain do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :active,
    :domainCode,
    :domainName,
    :recipientDomainId
  ]

  @type t :: %__MODULE__{
          :active => String.t() | nil,
          :domainCode => String.t() | nil,
          :domainName => String.t() | nil,
          :recipientDomainId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.RecipientDomain do
  def decode(value, _options) do
    value
  end
end
