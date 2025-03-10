# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.UserAuthorizationCreateRequestWithId do
  @moduledoc """
  A user authorizations to create or update.
  """

  @derive Jason.Encoder
  defstruct [
    :agentUser,
    :authorizationId,
    :endDate,
    :permission,
    :startDate
  ]

  @type t :: %__MODULE__{
          :agentUser => DocuSign.Model.AuthorizationUser.t() | nil,
          :authorizationId => String.t() | nil,
          :endDate => String.t() | nil,
          :permission => String.t() | nil,
          :startDate => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:agentUser, :struct, DocuSign.Model.AuthorizationUser)
  end
end
