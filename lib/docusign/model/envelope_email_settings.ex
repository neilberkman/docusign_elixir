# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeEmailSettings do
  @moduledoc """
  Envelope email settings
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.BccEmailAddress

  @derive Jason.Encoder
  defstruct [
    :bccEmailAddresses,
    :replyEmailAddressOverride,
    :replyEmailNameOverride
  ]

  @type t :: %__MODULE__{
          :bccEmailAddresses => [BccEmailAddress.t()] | nil,
          :replyEmailAddressOverride => String.t() | nil,
          :replyEmailNameOverride => String.t() | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:bccEmailAddresses, :list, BccEmailAddress)
  end
end
