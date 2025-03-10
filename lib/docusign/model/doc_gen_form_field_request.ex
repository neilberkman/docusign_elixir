# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DocGenFormFieldRequest do
  @moduledoc """
  This object maps the document generation fields to their values.
  """

  @derive Jason.Encoder
  defstruct [
    :docGenFormFields
  ]

  @type t :: %__MODULE__{
          :docGenFormFields => [DocuSign.Model.DocGenFormFields.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:docGenFormFields, :list, DocuSign.Model.DocGenFormFields)
  end
end
