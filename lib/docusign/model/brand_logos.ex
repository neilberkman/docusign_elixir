# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BrandLogos do
  @moduledoc """
  The URIs for retrieving the logos that are associated with the brand.  These are read-only properties that provide a URI to logos in use. To update a logo use [AccountBrands: updateLogo](/docs/esign-rest-api/reference/accounts/accountbrands/updatelogo/).
  """

  @derive [Poison.Encoder]
  defstruct [
    :email,
    :primary,
    :secondary
  ]

  @type t :: %__MODULE__{
          :email => String.t() | nil,
          :primary => String.t() | nil,
          :secondary => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BrandLogos do
  def decode(value, _options) do
    value
  end
end
