# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AddressInformationInput do
  @moduledoc """
  Contains address input information.
  """

  @derive Jason.Encoder
  defstruct [
    :addressInformation,
    :displayLevelCode,
    :receiveInResponse
  ]

  @type t :: %__MODULE__{
          :addressInformation => DocuSign.Model.AddressInformation.t() | nil,
          :displayLevelCode => String.t() | nil,
          :receiveInResponse => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:addressInformation, :struct, DocuSign.Model.AddressInformation)
  end
end
