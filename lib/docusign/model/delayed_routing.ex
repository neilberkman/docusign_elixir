# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.DelayedRouting do
  @moduledoc """
  A complex element that specifies the delayed routing settings for the workflow step.
  """

  @derive Jason.Encoder
  defstruct [
    :resumeDate,
    :rules,
    :status
  ]

  @type t :: %__MODULE__{
          :resumeDate => String.t() | nil,
          :rules => [DocuSign.Model.EnvelopeDelayRule.t()] | nil,
          :status => String.t() | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:rules, :list, DocuSign.Model.EnvelopeDelayRule)
  end
end
