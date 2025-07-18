# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.EnvelopeCustomFields do
  @moduledoc """
  An envelope custom field enables you to collect custom data about envelopes on a per-envelope basis. You can then use the custom data for sorting, organizing, searching, and other downstream processes. For example, you can use custom fields to copy envelopes or data to multiple areas in Salesforce. eOriginal customers can eVault their documents from the web app on a per-envelope basis by setting an envelope custom field with a name like \"eVault with eOriginal?\" to \"Yes\" or \"No\".  When a user creates an envelope, the envelope custom fields display in the **Envelope Settings** section of the Docusign console. Envelope recipients do not see the envelope custom fields. For more information, see [Envelope Custom Fields](https://support.docusign.com/s/document-item?bundleId=pik1583277475390&topicId=qor1583277385137.html).
  """

  alias DocuSign.Deserializer
  alias DocuSign.Model.ListCustomField
  alias DocuSign.Model.TextCustomField

  @derive Jason.Encoder
  defstruct [
    :listCustomFields,
    :textCustomFields
  ]

  @type t :: %__MODULE__{
          :listCustomFields => [ListCustomField.t()] | nil,
          :textCustomFields => [TextCustomField.t()] | nil
        }

  def decode(value) do
    value
    |> Deserializer.deserialize(:listCustomFields, :list, ListCustomField)
    |> Deserializer.deserialize(:textCustomFields, :list, TextCustomField)
  end
end
