# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.BulkRecipientTabLabel do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :name,
    :value
  ]

  @type t :: %__MODULE__{
          :name => String.t() | nil,
          :value => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.BulkRecipientTabLabel do
  def decode(value, _options) do
    value
  end
end
