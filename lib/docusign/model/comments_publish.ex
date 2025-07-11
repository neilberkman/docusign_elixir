# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.CommentsPublish do
  @moduledoc """

  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.CommentPublish

  @derive Jason.Encoder
  defstruct [
    :commentsToPublish
  ]

  @type t :: %__MODULE__{
          :commentsToPublish => [CommentPublish.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:commentsToPublish, :list, CommentPublish)
  end
end
