# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountPasswordExpirePasswordDays do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :maximumDays,
    :minimumDays
  ]

  @type t :: %__MODULE__{
          :maximumDays => String.t() | nil,
          :minimumDays => String.t() | nil
        }

  def decode(value) do
    value
  end
end
