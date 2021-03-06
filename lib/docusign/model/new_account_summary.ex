# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.NewAccountSummary do
  @moduledoc """

  """

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
          :accountId => String.t(),
          :accountIdGuid => String.t(),
          :accountName => String.t(),
          :apiPassword => String.t(),
          :baseUrl => String.t(),
          :billingPlanPreview => BillingPlanPreview,
          :userId => String.t()
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.NewAccountSummary do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:billingPlanPreview, :struct, DocuSign.Model.BillingPlanPreview, options)
  end
end
