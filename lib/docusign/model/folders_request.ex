# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.FoldersRequest do
  @moduledoc """
  Information for a folder request.
  """

  @derive Jason.Encoder
  defstruct [
    :envelopeIds,
    :folders,
    :fromFolderId
  ]

  @type t :: %__MODULE__{
          :envelopeIds => [String.t()] | nil,
          :folders => [DocuSign.Model.Folder.t()] | nil,
          :fromFolderId => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:folders, :list, DocuSign.Model.Folder)
  end
end
