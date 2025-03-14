# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.JurisdictionSummary do
  @moduledoc """

  """

  @derive Jason.Encoder
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

  def decode(value) do
    value
  end
end
