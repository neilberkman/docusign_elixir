# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountMinimumPasswordLength do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :maximumLength,
    :minimumLength
  ]

  @type t :: %__MODULE__{
          :maximumLength => String.t() | nil,
          :minimumLength => String.t() | nil
        }

  def decode(value) do
    value
  end
end
