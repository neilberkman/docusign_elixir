# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.GroupBrands do
  @moduledoc """
  If your account includes multiple signing brands, you can use the groups functionality to assign different brands to different groups. This resource enables you to manage group brands.
  """

  @derive Jason.Encoder
  defstruct [
    :recipientBrandIdDefault,
    :senderBrandIdDefault,
    :brandOptions
  ]

  @type t :: %__MODULE__{
          :recipientBrandIdDefault => String.t() | nil,
          :senderBrandIdDefault => String.t() | nil,
          :brandOptions => [DocuSign.Model.Brand.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:brandOptions, :list, DocuSign.Model.Brand)
  end
end
