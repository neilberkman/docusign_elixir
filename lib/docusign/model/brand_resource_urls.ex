# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BrandResourceUrls do
  @moduledoc """
  Brands use resource files to style the following experiences:   - Email - Sending - Signing - Captive (embedded) signing   You can modify these resource files to customize these experiences.
  """

  @derive [Poison.Encoder]
  defstruct [
    :email,
    :sending,
    :signing,
    :signingCaptive
  ]

  @type t :: %__MODULE__{
          :email => String.t() | nil,
          :sending => String.t() | nil,
          :signing => String.t() | nil,
          :signingCaptive => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BrandResourceUrls do
  def decode(value, _options) do
    value
  end
end
