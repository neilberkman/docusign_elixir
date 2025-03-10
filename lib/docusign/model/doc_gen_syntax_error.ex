# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DocGenSyntaxError do
  @moduledoc """
  Describes document generation errors.
  """

  @derive Jason.Encoder
  defstruct [
    :errorCode,
    :message,
    :tagIdentifier
  ]

  @type t :: %__MODULE__{
          :errorCode => String.t() | nil,
          :message => String.t() | nil,
          :tagIdentifier => String.t() | nil
        }

  def decode(value) do
    value
  end
end
