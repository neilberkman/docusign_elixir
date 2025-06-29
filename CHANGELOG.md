# Changelog

## v2.2.1

### New Features
- **Environment Auto-Detection**: Automatic sandbox vs production environment detection based on API URLs
  - Add `DocuSign.Util.Environment` module with hostname detection logic matching Ruby client behavior
  - Automatically determine OAuth hostname (`account-d.docusign.com` vs `account.docusign.com`) from base URIs
  - Add `DocuSign.Connection.determine_hostname/1` and `detect_environment/1` convenience functions
  - Add `DocuSign.Connection.from_oauth_client_with_detection/2` for automatic hostname configuration
  - Environment validation functions to ensure hostname/URI consistency
  - Complete test coverage with 37 test cases covering all URL patterns and edge cases

- **File Download Support**: Built-in utilities for downloading and handling DocuSign documents
  - Add `DocuSign.FileDownloader` module with multiple download strategies (memory, temp file, specific path)
  - Automatic filename extraction from Content-Disposition headers with RFC 6266 support
  - Intelligent temporary file management using the `temp` library with automatic cleanup
  - Content-Type validation and file size limits
  - Multiple file format support (PDF, HTML, images, etc.)
  - Add `DocuSign.Connection.download_file/3` convenience function
  - Comprehensive test coverage with 31 test cases

### Enhancements
- Add comprehensive SSL/TLS configuration support
  - Custom CA certificates and certificate validation
  - Client certificate authentication (mutual TLS)
  - Per-request SSL option overrides
  - Automatic system CA certificate detection
  - Connection pooling configuration
- Add `DocuSign.SSLOptions` module for managing SSL configuration
- Update `DocuSign.Connection` to support per-request SSL options
- Enhance Finch integration with SSL transport options
- Add `temp` dependency for robust temporary file handling
- Filename sanitization to prevent path traversal attacks
- Configurable download validation and security options

### Documentation
- Add extensive SSL/TLS configuration documentation to README
- Include security best practices for certificate validation
- Document connection pooling options
- Complete API documentation for all download functions with examples
- Security best practices for file downloads

## v2.2.0

### New Features
- **OAuth2 Authorization Code Flow Support**: Complete implementation of OAuth2 Authorization Code Flow using the battle-tested `oauth2` library
  - Add `DocuSign.OAuth.AuthorizationCodeStrategy` module implementing OAuth2.Strategy behavior
  - Add `DocuSign.Connection.from_oauth_client/2` for creating connections from OAuth2.Client
  - Support automatic token refresh and user info retrieval
  - Comprehensive test coverage for OAuth2 flow
- **Interactive LiveBook Guide**: New OAuth2 Authorization Code Flow LiveBook with:
  - Complete end-to-end OAuth flow demonstration
  - Built-in Bandit web server for OAuth callbacks
  - Automatic authorization code capture and token exchange
  - Real API testing with DocuSign accounts
  - Production implementation examples and best practices

### Enhancements
- Add model files to Dialyzer ignore list to prevent analysis of auto-generated code
- Add IDEAS.md document cataloging potential improvements from Ruby client
- Add changelog link to Hex package metadata for better discoverability
- Remove unnecessary `plug_cowboy` dependency (only used transitively by test dependencies)
- Update documentation with comprehensive OAuth2 examples
- Add OAuth2 support to README with complete usage patterns

### Documentation
- Create IDEAS.md to track feature ideas and improvements from other DocuSign clients

### Breaking Changes
- None (fully backward compatible)

## v2.1.0

### Enhancements
- Add support for Elixir 1.18.4 and OTP 28
- Migrate from Tesla.Builder to runtime configuration to fix deprecation warnings
- Switch from Mint to Finch adapter for better performance and connection pooling
- Add CI testing matrix to test against multiple Elixir/OTP version combinations:
  - Elixir 1.16.0 with OTP 26.0 (earliest supported)
  - Elixir 1.16.3 with OTP 26.2
  - Elixir 1.17.3 with OTP 27.1
  - Elixir 1.18.1 with OTP 27.2
  - Elixir 1.18.4 with OTP 28.0 (latest)
- Update dependencies to latest versions:
  - castore 1.0.12 → 1.0.14
  - ex_doc 0.38.0 → 0.38.2
  - plug_cowboy 2.7.3 → 2.7.4
  - tesla 1.14.1 → 1.14.3
  - mix_test_watch 1.2.0 → 1.3.0
  - credo 1.7.11 → 1.7.12
  - mime 2.0.6 → 2.0.7 (transitive)
  - plug 1.17.0 → 1.18.0 (transitive)

### Bug Fixes
- Fix deprecated `use Plug.Test` warning by using `import Plug.Test` and `import Plug.Conn`
- Fix HTTP method case sensitivity for Finch adapter (`:GET` → `:get`)
- Update timeout configuration to use Finch's `receive_timeout` option

### Internal Changes
- Start Finch supervisor in both test and production environments
- Add Tesla deprecation warning suppression to config
- Remove explicit Mint dependency as it's included transitively via Finch
- Update LiveBook example to use Kino 0.16.0
- Update LiveBook to use local path for testing unreleased changes
- Add Quokka formatter plugin for enhanced code formatting
- Apply consistent code formatting across entire codebase
- Add .git-blame-ignore-revs to ignore formatting commits in git blame

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
