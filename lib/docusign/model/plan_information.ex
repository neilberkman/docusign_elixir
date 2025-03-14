# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PlanInformation do
  @moduledoc """
  An object used to identify the features and attributes of the account being created.
  """

  @derive Jason.Encoder
  defstruct [
    :addOns,
    :currencyCode,
    :freeTrialDaysOverride,
    :planFeatureSets,
    :planId,
    :recipientDomains
  ]

  @type t :: %__MODULE__{
          :addOns => [DocuSign.Model.AddOn.t()] | nil,
          :currencyCode => String.t() | nil,
          :freeTrialDaysOverride => String.t() | nil,
          :planFeatureSets => [DocuSign.Model.FeatureSet.t()] | nil,
          :planId => String.t() | nil,
          :recipientDomains => [DocuSign.Model.RecipientDomain.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:addOns, :list, DocuSign.Model.AddOn)
    |> Deserializer.deserialize(:planFeatureSets, :list, DocuSign.Model.FeatureSet)
    |> Deserializer.deserialize(:recipientDomains, :list, DocuSign.Model.RecipientDomain)
  end
end
