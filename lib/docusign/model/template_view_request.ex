# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.TemplateViewRequest do
  @moduledoc """

  """

  @derive Jason.Encoder
  defstruct [
    :returnUrl,
    :viewAccess
  ]

  @type t :: %__MODULE__{
          :returnUrl => String.t() | nil,
          :viewAccess => String.t() | nil
        }

  def decode(value) do
    value
  end
end
