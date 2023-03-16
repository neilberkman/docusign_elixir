# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BccEmailArchiveHistory do
  @moduledoc """
  Contains details about the history of the BCC email archive configuration.
  """

  @derive [Poison.Encoder]
  defstruct [
    :accountId,
    :action,
    :email,
    :modified,
    :modifiedBy,
    :status
  ]

  @type t :: %__MODULE__{
          :accountId => String.t() | nil,
          :action => String.t() | nil,
          :email => String.t() | nil,
          :modified => String.t() | nil,
          :modifiedBy => DocuSign.Model.UserInfo.t() | nil,
          :status => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BccEmailArchiveHistory do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:modifiedBy, :struct, DocuSign.Model.UserInfo, options)
  end
end
