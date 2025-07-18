# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeAuditEvent do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.NameValue

  @derive Jason.Encoder
  defstruct [
    :eventFields
  ]

  @type t :: %__MODULE__{
          :eventFields => [NameValue.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:eventFields, :list, NameValue)
  end
end
