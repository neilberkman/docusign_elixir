defmodule DocuSign.Model.RecipientViewUrl do
  @moduledoc """
  A model representing the response from a recipient view URL request.
  """

  @derive [Jason.Encoder]
  defstruct [
    :url
  ]

  @type t :: %__MODULE__{
          :url => String.t() | nil
        }
end

# For Jason, we don't need to implement a decoder since Jason doesn't have a Decoder protocol.
# Instead, we'll handle this in the deserializer module.
