# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.SignatureGroupDef do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :groupId,
    :rights
  ]

  @type t :: %__MODULE__{
          :groupId => String.t() | nil,
          :rights => String.t() | nil
        }

  def decode(value) do
    value
  end
end
