# Changelog

## v2.0.0

### Breaking Changes
- Removed deprecated function `DocuSign.Connection.new/0`
- Removed deprecated function `DocuSign.Connection.default_account/0`
- Removed deprecated `:private_key` configuration option (use `:private_key_file` or `:private_key_contents`)
- See [MIGRATING.md](MIGRATING.md) for migration guidance

### Enhancements
- Improved code organization by removing deprecated code
- Updated LiveBook example to work with v2.0.0
- Made LiveBook example more prominently featured in documentation

## v1.4.0

### Enhancements

- Migrated from Poison to Jason for all JSON operations
  - Much faster JSON encoding/decoding (Jason is generally 2-3x faster than Poison)
  - Better compatibility with modern Elixir ecosystem
  - Maintains backward compatibility with existing code
- Updated all model modules to use `@derive Jason.Encoder` instead of Poison
- Modified RequestBuilder to use Jason.encode! for request serialization
- Updated Deserializer to use Jason.decode for response deserialization
- Updated OAuth2 client implementation to use Jason as serializer
- Fixed Tesla middleware to use Jason for JSON encoding
- Ensured Connection module properly handles different response formats
- Improved LiveBook example for embedded signing with better state management
- Improved ModelCleaner implementation for nil value removal
- Updated ModelCleaner tests with more comprehensive coverage
- Added Credo configuration to exclude auto-generated model files from linting

### API Enhancements

- Added several new model modules from latest DocuSign API:
  - EnvelopeViewDocumentSettings
  - EnvelopeViewEnvelopeCustomFieldSettings
  - EnvelopeViewRecipientSettings
  - EnvelopeViewRequest
  - EnvelopeViewSettings
  - EnvelopeViewTaggerSettings
  - EnvelopeViewTemplateSettings
  - ExternalPrimaryAccountSafelistAuthRequirements
  - Number
  - PaletteItemSettings
  - PaletteSettings
  - TemplateAutoMatch
  - TemplateAutoMatchList
  - TemplateViewRequest
  - Various UserAuthorization-related models

### Documentation

- Updated documentation to reflect the use of Jason for JSON handling
- Improved embedded signing LiveBook example with better state management

## v1.3.1

### Bug Fixes

- Fixed "INVALID_REQUEST_BODY" errors that occurred when using embedded signing functionality
- Added ModelCleaner module to recursively remove nil values from nested structs before serializing to JSON
- Updated RequestBuilder to clean request bodies of nil values, fixing the issue transparently
- Added example livebook showing embedded signing workflow
- Note: The example Livebook demonstrates using `body:` parameter for envelope creation as expected by the Elixir client

## v1.3.0

### Breaking Changes

- Update minimum Elixir version support to "~> 1.16 or ~> 1.17 or ~> 1.18"
- Update Poison dependency to "~> 6.0"

### Enhancements

- Fix contract type specs to match actual function implementations across the codebase
- Add proper moduledocs and cleanup module documentation
- Add dialyzer configuration to handle auto-generated code

### Housekeeping

- Update dependencies to latest versions
- Replace empty @moduledoc with @moduledoc false for generated modules
- Update toolchain versions (Erlang 27.2, Elixir 1.18.1, Node 21.7.3)

## v1.2.0

### Enhancements

- Add support for configuring the private key using either `:private_key_file`
  or `:private_key_contents`. - `:private_key_file` accepts a file path to the private key, exactly like
  `:private_key`. - `:private_key_contents` is the contents of the private key, typically
  retrieved from a secrets store.

### Deprecations

- Configuring the private key with `:private_key` was deprecated in favour of
  either `:private_key_file` (same semantics) or `:private_key_contents`.

## v1.1.3

### Enhancements

- Add support for configuring underlying Tesla adapter.
- Add webhook plug to simplify DocuSign Connect integration.

## v1.1.2

### Breaking changes

- Increase minimum version of dependencies

## v1.1.1

### Breaking Changes

- Change minimum Elixir version to 1.12
- Increase minimum version of dependencies
