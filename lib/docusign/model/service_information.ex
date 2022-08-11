# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.ServiceInformation do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :buildBranch,
    :buildBranchDeployedDateTime,
    :buildSHA,
    :buildVersion,
    :linkedSites,
    :serviceVersions
  ]

  @type t :: %__MODULE__{
    :buildBranch => String.t | nil,
    :buildBranchDeployedDateTime => String.t | nil,
    :buildSHA => String.t | nil,
    :buildVersion => String.t | nil,
    :linkedSites => [String.t] | nil,
    :serviceVersions => [DocuSign.Model.ServiceVersion.t] | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.ServiceInformation do
  import DocuSign.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:serviceVersions, :list, DocuSign.Model.ServiceVersion, options)
  end
end
