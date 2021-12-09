# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Model.EnvelopeDocumentTabs do
  @moduledoc """
  Envelope Document Tabs resource
  """

  @derive [Poison.Encoder]
  defstruct [
    :approveTabs,
    :checkboxTabs,
    :companyTabs,
    :dateSignedTabs,
    :dateTabs,
    :declineTabs,
    :emailAddressTabs,
    :emailTabs,
    :envelopeIdTabs,
    :firstNameTabs,
    :formulaTabs,
    :fullNameTabs,
    :initialHereTabs,
    :lastNameTabs,
    :listTabs,
    :notarizeTabs,
    :noteTabs,
    :numberTabs,
    :radioGroupTabs,
    :signerAttachmentTabs,
    :signHereTabs,
    :ssnTabs,
    :tabGroups,
    :textTabs,
    :titleTabs,
    :viewTabs,
    :zipTabs
  ]

  @type t :: %__MODULE__{
          :approveTabs => [Approve],
          :checkboxTabs => [Checkbox],
          :companyTabs => [Company],
          :dateSignedTabs => [DateSigned],
          :dateTabs => [DateTime],
          :declineTabs => [Decline],
          :emailAddressTabs => [EmailAddress],
          :emailTabs => [Email],
          :envelopeIdTabs => [EnvelopeId],
          :firstNameTabs => [FirstName],
          :formulaTabs => [FormulaTab],
          :fullNameTabs => [FullName],
          :initialHereTabs => [InitialHere],
          :lastNameTabs => [LastName],
          :listTabs => [List],
          :notarizeTabs => [Notarize],
          :noteTabs => [Note],
          :numberTabs => [Number],
          :radioGroupTabs => [RadioGroup],
          :signerAttachmentTabs => [SignerAttachment],
          :signHereTabs => [SignHere],
          :ssnTabs => [Ssn],
          :tabGroups => [TabGroup],
          :textTabs => [Text],
          :titleTabs => [Title],
          :viewTabs => [View],
          :zipTabs => [Zip]
        }
end

defimpl Poison.Decoder, for: DocuSign.Model.EnvelopeDocumentTabs do
  import DocuSign.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:approveTabs, :list, DocuSign.Model.Approve, options)
    |> deserialize(:checkboxTabs, :list, DocuSign.Model.Checkbox, options)
    |> deserialize(:companyTabs, :list, DocuSign.Model.Company, options)
    |> deserialize(:dateSignedTabs, :list, DocuSign.Model.DateSigned, options)
    |> deserialize(:dateTabs, :list, DocuSign.Model.Date, options)
    |> deserialize(:declineTabs, :list, DocuSign.Model.Decline, options)
    |> deserialize(:emailAddressTabs, :list, DocuSign.Model.EmailAddress, options)
    |> deserialize(:emailTabs, :list, DocuSign.Model.Email, options)
    |> deserialize(:envelopeIdTabs, :list, DocuSign.Model.EnvelopeId, options)
    |> deserialize(:firstNameTabs, :list, DocuSign.Model.FirstName, options)
    |> deserialize(:formulaTabs, :list, DocuSign.Model.FormulaTab, options)
    |> deserialize(:fullNameTabs, :list, DocuSign.Model.FullName, options)
    |> deserialize(:initialHereTabs, :list, DocuSign.Model.InitialHere, options)
    |> deserialize(:lastNameTabs, :list, DocuSign.Model.LastName, options)
    |> deserialize(:notarizeTabs, :list, DocuSign.Model.Notarize, options)
    |> deserialize(:noteTabs, :list, DocuSign.Model.Note, options)
    |> deserialize(:numberTabs, :list, DocuSign.Model.Number, options)
    |> deserialize(:radioGroupTabs, :list, DocuSign.Model.RadioGroup, options)
    |> deserialize(:signerAttachmentTabs, :list, DocuSign.Model.SignerAttachment, options)
    |> deserialize(:signHereTabs, :list, DocuSign.Model.SignHere, options)
    |> deserialize(:ssnTabs, :list, DocuSign.Model.Ssn, options)
    |> deserialize(:tabGroups, :list, DocuSign.Model.TabGroup, options)
    |> deserialize(:textTabs, :list, DocuSign.Model.Text, options)
    |> deserialize(:titleTabs, :list, DocuSign.Model.Title, options)
    |> deserialize(:viewTabs, :list, DocuSign.Model.View, options)
    |> deserialize(:zipTabs, :list, DocuSign.Model.Zip, options)
  end
end
