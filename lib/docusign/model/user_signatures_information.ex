# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.UserSignaturesInformation do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :userSignatures
  ]

  @type t :: %__MODULE__{
          :userSignatures => [DocuSign.Model.UserSignature.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.UserSignaturesInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:userSignatures, :list, DocuSign.Model.UserSignature, options)
  end
end
