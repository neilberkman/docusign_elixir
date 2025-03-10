# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountAddress do
  @moduledoc """
  Contains information about the address associated with the account.
  """

  @derive Jason.Encoder
  defstruct [
    :address1,
    :address2,
    :city,
    :country,
    :email,
    :fax,
    :firstName,
    :lastName,
    :phone,
    :postalCode,
    :state,
    :supportedCountries
  ]

  @type t :: %__MODULE__{
          :address1 => String.t() | nil,
          :address2 => String.t() | nil,
          :city => String.t() | nil,
          :country => String.t() | nil,
          :email => String.t() | nil,
          :fax => String.t() | nil,
          :firstName => String.t() | nil,
          :lastName => String.t() | nil,
          :phone => String.t() | nil,
          :postalCode => String.t() | nil,
          :state => String.t() | nil,
          :supportedCountries => [DocuSign.Model.Country.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:supportedCountries, :list, DocuSign.Model.Country)
  end
end
