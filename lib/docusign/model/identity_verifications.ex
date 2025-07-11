# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.IdentityVerifications do
  @moduledoc """
  Identity Verification enables you to verify a signer's identity before they can access a document. The `IdentityVerifications` resource provides a method that enables you to list the workflows that are available to an account.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.AccountIdentityVerificationWorkflow

  @derive Jason.Encoder
  defstruct [
    :identityVerification
  ]

  @type t :: %__MODULE__{
          :identityVerification => [AccountIdentityVerificationWorkflow.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :identityVerification,
      :list,
      AccountIdentityVerificationWorkflow
    )
  end
end
