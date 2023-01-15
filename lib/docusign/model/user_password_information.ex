# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.UserPasswordInformation do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :currentPassword,
    :email,
    :forgottenPasswordInfo,
    :newPassword
  ]

  @type t :: %__MODULE__{
          :currentPassword => String.t() | nil,
          :email => String.t() | nil,
          :forgottenPasswordInfo => DocuSign.Model.ForgottenPasswordInformation.t() | nil,
          :newPassword => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.UserPasswordInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :forgottenPasswordInfo,
      :struct,
      DocuSign.Model.ForgottenPasswordInformation,
      options
    )
  end
end
