# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DocGenFormFieldOption do
  @moduledoc """
  Specifies an individual option setting when type is `Select`.
  """

  @derive Jason.Encoder
  defstruct [
    :description,
    :label,
    :selected,
    :value
  ]

  @type t :: %__MODULE__{
          :description => String.t() | nil,
          :label => String.t() | nil,
          :selected => String.t() | nil,
          :value => String.t() | nil
        }

  def decode(value) do
    value
  end
end
