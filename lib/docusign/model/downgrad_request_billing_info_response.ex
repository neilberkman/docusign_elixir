# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DowngradRequestBillingInfoResponse do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :downgradePlanInformation,
    :paymentMethod
  ]

  @type t :: %__MODULE__{
          :downgradePlanInformation => DocuSign.Model.DowngradePlanUpdateResponse.t() | nil,
          :paymentMethod => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :downgradePlanInformation,
      :struct,
      DocuSign.Model.DowngradePlanUpdateResponse
    )
  end
end
