# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientPreviewRequest do
  @moduledoc """
  This request object contains the information necessary to create a recipient preview.
  """

  @derive Jason.Encoder
  defstruct [
    :assertionId,
    :authenticationInstant,
    :authenticationMethod,
    :clientURLs,
    :pingFrequency,
    :pingUrl,
    :recipientId,
    :returnUrl,
    :securityDomain,
    :xFrameOptions,
    :xFrameOptionsAllowFromUrl
  ]

  @type t :: %__MODULE__{
          :assertionId => String.t() | nil,
          :authenticationInstant => String.t() | nil,
          :authenticationMethod => String.t() | nil,
          :clientURLs => DocuSign.Model.RecipientTokenClientUrls.t() | nil,
          :pingFrequency => String.t() | nil,
          :pingUrl => String.t() | nil,
          :recipientId => String.t() | nil,
          :returnUrl => String.t() | nil,
          :securityDomain => String.t() | nil,
          :xFrameOptions => String.t() | nil,
          :xFrameOptionsAllowFromUrl => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:clientURLs, :struct, DocuSign.Model.RecipientTokenClientUrls)
  end
end
