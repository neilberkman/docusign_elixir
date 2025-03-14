# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BillingPlansResponse do
  @moduledoc """
  Defines a billing plans response object.
  """

  @derive Jason.Encoder
  defstruct [
    :billingPlans
  ]

  @type t :: %__MODULE__{
          :billingPlans => [DocuSign.Model.BillingPlan.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:billingPlans, :list, DocuSign.Model.BillingPlan)
  end
end
