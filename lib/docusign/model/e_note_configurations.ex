# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ENoteConfigurations do
  @moduledoc """

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
