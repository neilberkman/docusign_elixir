# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.LoginInformation do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :apiPassword,
    :loginAccounts
  ]

  @type t :: %__MODULE__{
          :apiPassword => String.t() | nil,
          :loginAccounts => [DocuSign.Model.LoginAccount.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:loginAccounts, :list, DocuSign.Model.LoginAccount)
  end
end
