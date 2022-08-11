# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.DowngradeRequestInformation do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :downgradeRequestCreation,
    :downgradeRequestProductId,
    :downgradeRequestStatus
  ]

  @type t :: %__MODULE__{
    :downgradeRequestCreation => String.t | nil,
    :downgradeRequestProductId => String.t | nil,
    :downgradeRequestStatus => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.DowngradeRequestInformation do
  def decode(value, _options) do
    value
  end
end
