# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.Province do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :isoCode,
    :name
  ]

  @type t :: %__MODULE__{
          :isoCode => String.t() | nil,
          :name => String.t() | nil
        }

  def decode(value) do
    value
  end
end
