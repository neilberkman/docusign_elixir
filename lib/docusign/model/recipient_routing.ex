# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.RecipientRouting do
  @moduledoc """
  Describes the recipient routing rules.
  """

  @derive Jason.Encoder
  defstruct [
    :rules
  ]

  @type t :: %__MODULE__{
          :rules => DocuSign.Model.RecipientRules.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:rules, :struct, DocuSign.Model.RecipientRules)
  end
end
