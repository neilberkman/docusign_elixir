# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.CaptiveRecipient do
  @moduledoc """
  This object contains details about a captive (embedded) recipient.
  """

  @derive Jason.Encoder
  defstruct [
    :clientUserId,
    :email,
    :errorDetails,
    :userName
  ]

  @type t :: %__MODULE__{
          :clientUserId => String.t() | nil,
          :email => String.t() | nil,
          :errorDetails => DocuSign.Model.ErrorDetails.t() | nil,
          :userName => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:errorDetails, :struct, DocuSign.Model.ErrorDetails)
  end
end
