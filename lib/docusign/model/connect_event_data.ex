# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.ConnectEventData do
  @moduledoc """
  This object lets you choose the data format of your Connect response. For  more information about using this object, see [Connect webhooks with JSON notifications](https://www.docusign.com/blog/developers/connect-webhooks-json-notifications). 
  """

  @derive [Poison.Encoder]
  defstruct [
    :format,
    :includeData,
    :version
  ]

  @type t :: %__MODULE__{
    :format => String.t | nil,
    :includeData => [String.t] | nil,
    :version => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.ConnectEventData do
  def decode(value, _options) do
    value
  end
end
