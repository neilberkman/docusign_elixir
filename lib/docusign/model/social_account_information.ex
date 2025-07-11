# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.SocialAccountInformation do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.ErrorDetails

  @derive Jason.Encoder
  defstruct [
    :email,
    :errorDetails,
    :provider,
    :socialId,
    :userName
  ]

  @type t :: %__MODULE__{
          :email => String.t() | nil,
          :errorDetails => ErrorDetails.t() | nil,
          :provider => String.t() | nil,
          :socialId => String.t() | nil,
          :userName => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, ErrorDetails)
  end
end
