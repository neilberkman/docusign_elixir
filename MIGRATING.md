# Migrating to `v2.0` from `v1.x`

Version 2.0.0 removes previously deprecated functionality. If you're still using any of these functions or configuration options, you'll need to update your code:

- Removed `DocuSign.Connection.new/0` - use `DocuSign.Connection.get/1` and provide a user ID
- Removed `DocuSign.Connection.default_account/0` - the app_account is included in the connection returned by `DocuSign.Connection.get/1`
- Removed `:private_key` configuration option - use `:private_key_file` or `:private_key_contents` instead

## Migrating to `v0.4.0` from `v0.3.x`

Version 0.4.0 brings the ability to call DocuSign API with different user IDs. This is useful if your users have different security restrictions in DocuSign. The `ClientRegistry` takes care of tracking the API client for those users and refreshing the access tokens.

- `Connection.new/0` has been deprecated. You should replace calls to `Connection.new/0` with `Connection.get/1` and provide a user ID.
- `APIClient` functions have been deprecated. Please use corresponding functions in `ClientRegistry`.

## Migrating to `v1.0` from an earlier version

This version contains some breaking changes. You may need to modify your code.

- `DocuSign.Model.EnvelopeTemplateResult` has been renamed to `DocuSign.Model.EnvelopeTemplate`
- `DocuSign.Model.Number` has been renamed to `DocuSign.Model.DocuSignNumber`
- Use `body` as an optional argument to some functions, e.g. use `body` instead of `EnvelopeRecipientTabs` when calling `DocuSign.Api.EnvelopeRecipientTabs.recipients_put_recipient_tabs()`)
