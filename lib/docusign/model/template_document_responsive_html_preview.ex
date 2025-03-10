# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TemplateDocumentResponsiveHtmlPreview do
  @moduledoc """
  This resource is used to create a responsive preview of a specific template document.
  """

  @derive Jason.Encoder
  defstruct [
    :htmlDefinitions
  ]

  @type t :: %__MODULE__{
          :htmlDefinitions => [String.t()] | nil
        }

  def decode(value) do
    value
  end
end
