# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ServerTemplate do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :sequence,
    :templateId
  ]

  @type t :: %__MODULE__{
          :sequence => String.t() | nil,
          :templateId => String.t() | nil
        }

  def decode(value) do
    value
  end
end
