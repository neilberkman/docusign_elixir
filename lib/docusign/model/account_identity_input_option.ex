# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountIdentityInputOption do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :isRequired,
    :optionName,
    :valueType
  ]

  @type t :: %__MODULE__{
          :isRequired => boolean() | nil,
          :optionName => String.t() | nil,
          :valueType => String.t() | nil
        }

  def decode(value) do
    value
  end
end
