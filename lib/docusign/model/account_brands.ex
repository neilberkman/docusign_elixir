# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountBrands do
  @moduledoc """
  The AccountBrands resource enables you to use account-level brands to customize the styles and text that recipients see.
  """

  @derive Jason.Encoder
  defstruct [
    :brands,
    :recipientBrandIdDefault,
    :senderBrandIdDefault
  ]

  @type t :: %__MODULE__{
          :brands => [DocuSign.Model.Brand.t()] | nil,
          :recipientBrandIdDefault => String.t() | nil,
          :senderBrandIdDefault => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:brands, :list, DocuSign.Model.Brand)
  end
end
