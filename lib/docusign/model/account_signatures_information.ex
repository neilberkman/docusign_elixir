# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountSignaturesInformation do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :accountSignatures
  ]

  @type t :: %__MODULE__{
          :accountSignatures => [DocuSign.Model.AccountSignature.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.AccountSignaturesInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:accountSignatures, :list, DocuSign.Model.AccountSignature, options)
  end
end
