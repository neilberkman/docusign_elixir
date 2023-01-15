# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.AccountPasswordQuestionsRequired do
  @moduledoc """
  Information about the number of password questions required (0 to 4) to confirm a user's identity when a user needs to reset their password.
  """

  @derive [Poison.Encoder]
  defstruct [
    :maximumQuestions,
    :minimumQuestions
  ]

  @type t :: %__MODULE__{
          :maximumQuestions => String.t() | nil,
          :minimumQuestions => String.t() | nil
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.AccountPasswordQuestionsRequired do
  def decode(value, _options) do
    value
  end
end
