# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TemplateViews do
  @moduledoc """
  A TemplateView contains a URL that you can embed in your application to generate a template view that uses the Docusign user interface (UI).
  """

  @derive Jason.Encoder
  defstruct [
    :url
  ]

  @type t :: %__MODULE__{
          :url => String.t() | nil
        }

  def decode(value) do
    value
  end
end
