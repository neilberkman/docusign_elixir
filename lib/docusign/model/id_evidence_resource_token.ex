# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.IdEvidenceResourceToken do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :proofBaseURI,
    :resourceToken
  ]

  @type t :: %__MODULE__{
          :proofBaseURI => String.t() | nil,
          :resourceToken => String.t() | nil
        }

  def decode(value) do
    value
  end
end
