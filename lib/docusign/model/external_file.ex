# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.ExternalFile do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :date,
    :id,
    :img,
    :name,
    :size,
    :supported,
    :type,
    :uri
  ]

  @type t :: %__MODULE__{
          :date => String.t(),
          :id => String.t(),
          :img => String.t(),
          :name => String.t(),
          :size => String.t(),
          :supported => String.t(),
          :type => String.t(),
          :uri => String.t()
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.ExternalFile do
  def decode(value, _options) do
    value
  end
end
