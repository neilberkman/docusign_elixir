# Migrating to `v1.0.0` from an earlier version

This version contains some breaking changes. You may need to modify your code.

- `DocuSign.Model.EnvelopeTemplateResult` has been renamed to `DocuSign.Model.EnvelopeTemplate`
- `DocuSign.Model.Number` has been renamed to `DocuSign.Model.DocuSignNumber`
- Use `body` as an optional argument to some functions, e.g. use `body` instead of `EnvelopeRecipientTabs` when calling `DocuSign.Api.EnvelopeRecipientTabs.recipients_put_recipient_tabs()`)
