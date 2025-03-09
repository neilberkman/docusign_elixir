defmodule DocuSign.Model.RecipientViewUrl do
  @moduledoc """
  A model representing the response from a recipient view URL request.
  """

  @derive [Poison.Encoder]
  defstruct [
    :url
  ]

  @type t :: %__MODULE__{
          :url => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.RecipientViewUrl do
  def decode(value, _options) do
    value
  end
end
