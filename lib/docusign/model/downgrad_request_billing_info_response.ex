# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DowngradRequestBillingInfoResponse do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :downgradePlanInformation,
    :paymentMethod
  ]

  @type t :: %__MODULE__{
          :downgradePlanInformation => DocuSign.Model.DowngradePlanUpdateResponse.t() | nil,
          :paymentMethod => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.DowngradRequestBillingInfoResponse do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :downgradePlanInformation,
      :struct,
      DocuSign.Model.DowngradePlanUpdateResponse,
      options
    )
  end
end
