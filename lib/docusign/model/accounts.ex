# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Accounts do
  @moduledoc """
  Account management
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.AccountBrands
  alias DocuSign.Model.AccountSettingsInformation
  alias DocuSign.Model.RecipientDomain

  @derive Jason.Encoder
  defstruct [
    :accountIdGuid,
    :accountName,
    :accountSettings,
    :allowTransactionRooms,
    :billingPeriodDaysRemaining,
    :billingPeriodEndDate,
    :billingPeriodEnvelopesAllowed,
    :billingPeriodEnvelopesSent,
    :billingPeriodStartDate,
    :billingProfile,
    :brands,
    :canUpgrade,
    :connectPermission,
    :createdDate,
    :currencyCode,
    :currentPlanId,
    :displayApplianceStartUrl,
    :displayApplianceUrl,
    :distributorCode,
    :docuSignLandingUrl,
    :dssValues,
    :envelopeSendingBlocked,
    :envelopeUnitPrice,
    :externalAccountId,
    :forgottenPasswordQuestionsCount,
    :freeEnvelopeSendsRemainingForAdvancedDocGen,
    :isDowngrade,
    :paymentMethod,
    :planClassification,
    :planEndDate,
    :planName,
    :planStartDate,
    :recipientDomains,
    :seatsAllowed,
    :seatsInUse,
    :status21CFRPart11,
    :suspensionDate,
    :suspensionStatus,
    :useDisplayAppliance
  ]

  @type t :: %__MODULE__{
          :accountIdGuid => String.t() | nil,
          :accountName => String.t() | nil,
          :accountSettings => AccountSettingsInformation.t() | nil,
          :allowTransactionRooms => String.t() | nil,
          :billingPeriodDaysRemaining => String.t() | nil,
          :billingPeriodEndDate => String.t() | nil,
          :billingPeriodEnvelopesAllowed => String.t() | nil,
          :billingPeriodEnvelopesSent => String.t() | nil,
          :billingPeriodStartDate => String.t() | nil,
          :billingProfile => String.t() | nil,
          :brands => AccountBrands.t() | nil,
          :canUpgrade => String.t() | nil,
          :connectPermission => String.t() | nil,
          :createdDate => String.t() | nil,
          :currencyCode => String.t() | nil,
          :currentPlanId => String.t() | nil,
          :displayApplianceStartUrl => String.t() | nil,
          :displayApplianceUrl => String.t() | nil,
          :distributorCode => String.t() | nil,
          :docuSignLandingUrl => String.t() | nil,
          :dssValues => %{optional(String.t()) => String.t()} | nil,
          :envelopeSendingBlocked => String.t() | nil,
          :envelopeUnitPrice => String.t() | nil,
          :externalAccountId => String.t() | nil,
          :forgottenPasswordQuestionsCount => String.t() | nil,
          :freeEnvelopeSendsRemainingForAdvancedDocGen => integer() | nil,
          :isDowngrade => String.t() | nil,
          :paymentMethod => String.t() | nil,
          :planClassification => String.t() | nil,
          :planEndDate => String.t() | nil,
          :planName => String.t() | nil,
          :planStartDate => String.t() | nil,
          :recipientDomains => [RecipientDomain.t()] | nil,
          :seatsAllowed => String.t() | nil,
          :seatsInUse => String.t() | nil,
          :status21CFRPart11 => String.t() | nil,
          :suspensionDate => String.t() | nil,
          :suspensionStatus => String.t() | nil,
          :useDisplayAppliance => boolean() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :accountSettings,
      :struct,
      AccountSettingsInformation
    )
    |> Deserializer.deserialize(:brands, :struct, AccountBrands)
    |> Deserializer.deserialize(:recipientDomains, :list, RecipientDomain)
  end
end
