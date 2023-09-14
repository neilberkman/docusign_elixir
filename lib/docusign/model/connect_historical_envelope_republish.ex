# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ConnectHistoricalEnvelopeRepublish do
  @moduledoc """
  The request body for the `createHistoricalEnvelopePublishTransaction` endpoint.
  """

  @derive [Poison.Encoder]
  defstruct [
    :config,
    :envelopes
  ]

  @type t :: %__MODULE__{
          :config => DocuSign.Model.ConnectCustomConfiguration.t() | nil,
          :envelopes => [String.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ConnectHistoricalEnvelopeRepublish do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:config, :struct, DocuSign.Model.ConnectCustomConfiguration, options)
  end
end