# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ResponsiveHtmlPreview do
  @moduledoc """
  This resource is used to create a responsive preview of all of the documents in an envelope.
  """

  @derive [Poison.Encoder]
  defstruct [
    :htmlDefinitions
  ]

  @type t :: %__MODULE__{
          :htmlDefinitions => [String.t()] | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ResponsiveHtmlPreview do
  def decode(value, _options) do
    value
  end
end
