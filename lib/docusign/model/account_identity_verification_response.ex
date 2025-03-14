# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountIdentityVerificationResponse do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :identityVerification
  ]

  @type t :: %__MODULE__{
          :identityVerification => [DocuSign.Model.AccountIdentityVerificationWorkflow.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(
      :identityVerification,
      :list,
      DocuSign.Model.AccountIdentityVerificationWorkflow
    )
  end
end
