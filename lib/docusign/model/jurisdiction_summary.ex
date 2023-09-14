# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.JurisdictionSummary do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :authorizedForIPen,
    :authorizedForRon,
    :jurisdictionId,
    :jurisdictionName
  ]

  @type t :: %__MODULE__{
          :authorizedForIPen => String.t() | nil,
          :authorizedForRon => String.t() | nil,
          :jurisdictionId => String.t() | nil,
          :jurisdictionName => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.JurisdictionSummary do
  def decode(value, _options) do
    value
  end
end