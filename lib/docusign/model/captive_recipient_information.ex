# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.CaptiveRecipientInformation do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :captiveRecipients
  ]

  @type t :: %__MODULE__{
          :captiveRecipients => [CaptiveRecipient]
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.CaptiveRecipientInformation do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:captiveRecipients, :list, DocuSign.Model.CaptiveRecipient, options)
  end
end
