# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.NewUsersDefinition do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :newUsers
  ]

  @type t :: %__MODULE__{
          :newUsers => [DocuSign.Model.UserInformation.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:newUsers, :list, DocuSign.Model.UserInformation)
  end
end
