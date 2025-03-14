# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountPasswordStrengthType do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :options
  ]

  @type t :: %__MODULE__{
          :options => [DocuSign.Model.AccountPasswordStrengthTypeOption.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:options, :list, DocuSign.Model.AccountPasswordStrengthTypeOption)
  end
end
