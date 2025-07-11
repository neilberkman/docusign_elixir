# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.UserInformationList do
  @moduledoc """
  Contains a list of account users.
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.UserInformation

  @derive Jason.Encoder
  defstruct [
    :endPosition,
    :nextUri,
    :previousUri,
    :resultSetSize,
    :startPosition,
    :totalSetSize,
    :users
  ]

  @type t :: %__MODULE__{
          :endPosition => String.t() | nil,
          :nextUri => String.t() | nil,
          :previousUri => String.t() | nil,
          :resultSetSize => String.t() | nil,
          :startPosition => String.t() | nil,
          :totalSetSize => String.t() | nil,
          :users => [UserInformation.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:users, :list, UserInformation)
  end
end
