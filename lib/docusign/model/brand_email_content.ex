# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BrandEmailContent do
  @moduledoc """
  Deprecated.
  """

  @derive Jason.Encoder
  defstruct [
    :content,
    :emailContentType,
    :emailToLink,
    :linkText
  ]

  @type t :: %__MODULE__{
          :content => String.t() | nil,
          :emailContentType => String.t() | nil,
          :emailToLink => String.t() | nil,
          :linkText => String.t() | nil
        }

  def decode(value) do
    value
  end
end
