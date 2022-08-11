# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Model.CommentHistoryResult do
  @moduledoc """
  
  """

  @derive [Poison.Encoder]
  defstruct [
    :comments,
    :count,
    :endTimetoken,
    :startTimetoken
  ]

  @type t :: %__MODULE__{
    :comments => [DocuSign.Model.Comment.t] | nil,
    :count => integer() | nil,
    :endTimetoken => String.t | nil,
    :startTimetoken => String.t | nil
  }
end

defimpl Poison.Decoder, for: DocuSign.Model.CommentHistoryResult do
  import DocuSign.Deserializer
  def decode(value, options) do
    value
    |> deserialize(:comments, :list, DocuSign.Model.Comment, options)
  end
end
