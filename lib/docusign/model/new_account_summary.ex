# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.NewAccountSummary do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :accountId,
    :accountIdGuid,
    :accountName,
    :apiPassword,
    :baseUrl,
    :billingPlanPreview,
    :userId
  ]

  @type t :: %__MODULE__{
          :accountId => String.t() | nil,
          :accountIdGuid => String.t() | nil,
          :accountName => String.t() | nil,
          :apiPassword => String.t() | nil,
          :baseUrl => String.t() | nil,
          :billingPlanPreview => DocuSign.Model.BillingPlanPreview.t() | nil,
          :userId => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.NewAccountSummary do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:billingPlanPreview, :struct, DocuSign.Model.BillingPlanPreview, options)
  end
end
