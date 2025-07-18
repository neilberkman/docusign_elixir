# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ENoteConfiguration do
  @moduledoc """
  This object contains information used to configure [eNote][eNote] functionality. To use eNote, the Allow eNote for eOriginal account plan item must be on, and the Connect configuration for eOriginal must be set correctly.  [eNote]: https://support.docusign.com/s/document-item?bundleId=pik1583277475390&topicId=tsn1583277394951.html
  """

  @derive Jason.Encoder
  defstruct [
    :apiKey,
    :connectConfigured,
    :eNoteConfigured,
    :organization,
    :password,
    :userName
  ]

  @type t :: %__MODULE__{
          :apiKey => String.t() | nil,
          :connectConfigured => String.t() | nil,
          :eNoteConfigured => String.t() | nil,
          :organization => String.t() | nil,
          :password => String.t() | nil,
          :userName => String.t() | nil
        }

  def decode(value) do
    value
  end
end
