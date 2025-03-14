# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Model.PrefillTabs do
  @moduledoc """
  Prefill tabs are tabs that the sender can fill in before the envelope is sent. They are sometimes called sender tags or pre-fill fields.  Only the following tab types can be prefill tabs:  - text - check boxes - radio buttons    [Pre-Fill Your Own Document Fields][app] describes how prefill tabs work in the web application.   [Customize your envelopes with pre-fill fields][catblog] shows how to use prefill tabs in your application using the eSignature SDKs.  [app]:      https://support.docusign.com/s/document-item?bundleId=gbo1643332197980&topicId=nwo1611173513994.html [catblog]:  https://www.docusign.com/blog/developers/common-api-tasks-customize-your-envelopes-pre-fill-fields
  """

  @derive Jason.Encoder
  defstruct [
    :checkboxTabs,
    :dateTabs,
    :emailTabs,
    :numberTabs,
    :radioGroupTabs,
    :senderCompanyTabs,
    :senderNameTabs,
    :ssnTabs,
    :tabGroups,
    :textTabs,
    :zipTabs
  ]

  @type t :: %__MODULE__{
          :checkboxTabs => [DocuSign.Model.Checkbox.t()] | nil,
          :dateTabs => [DocuSign.Model.Date.t()] | nil,
          :emailTabs => [DocuSign.Model.Email.t()] | nil,
          :numberTabs => [DocuSign.Model.Float.t()] | nil,
          :radioGroupTabs => [DocuSign.Model.RadioGroup.t()] | nil,
          :senderCompanyTabs => [DocuSign.Model.SenderCompany.t()] | nil,
          :senderNameTabs => [DocuSign.Model.SenderName.t()] | nil,
          :ssnTabs => [DocuSign.Model.Ssn.t()] | nil,
          :tabGroups => [DocuSign.Model.TabGroup.t()] | nil,
          :textTabs => [DocuSign.Model.Text.t()] | nil,
          :zipTabs => [DocuSign.Model.Zip.t()] | nil
        }

  alias DocuSign.Deserializer

  def decode(value) do
    value
    |> Deserializer.deserialize(:checkboxTabs, :list, DocuSign.Model.Checkbox)
    |> Deserializer.deserialize(:dateTabs, :list, DocuSign.Model.Date)
    |> Deserializer.deserialize(:emailTabs, :list, DocuSign.Model.Email)
    |> Deserializer.deserialize(:radioGroupTabs, :list, DocuSign.Model.RadioGroup)
    |> Deserializer.deserialize(:senderCompanyTabs, :list, DocuSign.Model.SenderCompany)
    |> Deserializer.deserialize(:senderNameTabs, :list, DocuSign.Model.SenderName)
    |> Deserializer.deserialize(:ssnTabs, :list, DocuSign.Model.Ssn)
    |> Deserializer.deserialize(:tabGroups, :list, DocuSign.Model.TabGroup)
    |> Deserializer.deserialize(:textTabs, :list, DocuSign.Model.Text)
    |> Deserializer.deserialize(:zipTabs, :list, DocuSign.Model.Zip)
  end
end
