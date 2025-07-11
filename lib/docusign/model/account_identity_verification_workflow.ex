# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountIdentityVerificationWorkflow do
  @moduledoc """
  Specifies an Identity Verification workflow.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.AccountIdentityInputOption
  alias DocuSign.Model.AccountSignatureProvider

  @derive Jason.Encoder
  defstruct [
    :defaultDescription,
    :defaultName,
    :inputOptions,
    :isDisabled,
    :ownerType,
    :signatureProvider,
    :workflowId,
    :workflowLabel,
    :workflowResourceKey
  ]

  @type t :: %__MODULE__{
          :defaultDescription => String.t() | nil,
          :defaultName => String.t() | nil,
          :inputOptions => [AccountIdentityInputOption.t()] | nil,
          :isDisabled => String.t() | nil,
          :ownerType => String.t() | nil,
          :signatureProvider => AccountSignatureProvider.t() | nil,
          :workflowId => String.t() | nil,
          :workflowLabel => String.t() | nil,
          :workflowResourceKey => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:inputOptions, :list, AccountIdentityInputOption)
    |> Deserializer.deserialize(
      :signatureProvider,
      :struct,
      AccountSignatureProvider
    )
  end
end
