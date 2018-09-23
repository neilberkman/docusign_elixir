# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.CloudStorageProvider do
  @moduledoc false

  @derive [Poison.Encoder]
  defstruct [
    :authenticationUrl,
    :errorDetails,
    :redirectUrl,
    :service,
    :serviceId
  ]

  @type t :: %__MODULE__{
          :authenticationUrl => String.t(),
          :errorDetails => ErrorDetails,
          :redirectUrl => String.t(),
          :service => String.t(),
          :serviceId => String.t()
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.CloudStorageProvider do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails, options)
  end
end