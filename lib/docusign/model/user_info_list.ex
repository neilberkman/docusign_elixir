# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.UserInfoList do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :users
  ]

  @type t :: %__MODULE__{
          :users => [DocuSign.Model.UserInfo.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.UserInfoList do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:users, :list, DocuSign.Model.UserInfo, options)
  end
end
