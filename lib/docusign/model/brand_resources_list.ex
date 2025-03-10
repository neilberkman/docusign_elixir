# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BrandResourcesList do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :resourcesContentTypes
  ]

  @type t :: %__MODULE__{
          :resourcesContentTypes => [DocuSign.Model.BrandResources.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:resourcesContentTypes, :list, DocuSign.Model.BrandResources)
  end
end
