# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.ExternalDocServiceErrorDetails do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :authenticationUrl,
    :errorCode,
    :message
  ]

  @type t :: %__MODULE__{
          :authenticationUrl => String.t() | nil,
          :errorCode => String.t() | nil,
          :message => String.t() | nil
        }

  def decode(value) do
    value
  end
end
