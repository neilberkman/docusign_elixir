# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BrandResourcesList do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.BrandResources

  @derive Jason.Encoder
  defstruct [
    :resourcesContentTypes
  ]

  @type t :: %__MODULE__{
          :resourcesContentTypes => [BrandResources.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:resourcesContentTypes, :list, BrandResources)
  end
end
