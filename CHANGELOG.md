# Changelog

## Unreleased

### Improvements

- **Retry Logic**: Add configurable retry logic with exponential backoff
  - Automatic retry on transient failures (5xx errors, network issues)
  - Rate limit handling with Retry-After header support
  - Configurable max retries, backoff factor, and max delay
  - Exponential backoff with jitter to prevent thundering herd
  - Can be disabled by setting `retry_options: [enabled: false]`

- **Telemetry Integration**: Add comprehensive telemetry events for monitoring and observability
  - DocuSign-specific events for API operations (start, stop, exception)
  - Rate limit tracking with dedicated telemetry events
  - Integration with Finch telemetry for low-level HTTP metrics
  - Support for Telemetry.Metrics and production monitoring tools
  - Automatic operation name extraction from API paths
  - Detailed metadata including account ID, operation, status codes

- **SDK Version Management**: Add proper SDK identification and version reporting
  - User-Agent header includes SDK version, API version, and runtime info
  - Format: `docusign-elixir/3.0.0 (Elixir/1.18.4; OTP/28; API/v2.1)`
  - SDK metadata included in all telemetry events
  - Support for custom User-Agent suffix for app identification
  - Matches Ruby SDK pattern for version reporting

### Bug Fixes

- **Test Stability**: Fix flaky async tests caused by Mock library
  - Replace Mock-based tests with Bypass integration tests
  - Fix OAuth test log assertions to handle concurrent test execution
  - All tests now pass consistently with async: true

### Internal Changes

- **Documentation**: Add CLAUDE.md with critical CI requirements
- **Regeneration Script**: Update to handle correct OpenAPI Generator output paths
- **Removed Files**: Remove unused RecipientViewUrl model (API uses EnvelopeViews instead)
- **Dependencies**: Update ex_doc from 0.38.2 to 0.38.3

## v3.0.0 (2025-09-01)

### Breaking Changes

- **HTTP Client Migration**: Replace Tesla with Req HTTP client
  - Error responses now return `{:error, Req.Response}` instead of `{:error, Tesla.Env}`
  - Connection module internally uses Req instead of Tesla
  - Removed Tesla middleware system in favor of Req's request/response steps
  - Debug module's middleware functions are deprecated (use `sdk_headers()` directly)
  - Any code directly accessing error response structures will need updates

### Major Improvements

- **Removed Internal Workarounds**:
  - Eliminated ModelCleaner hack - Req properly handles nil values in request bodies
  - No more INVALID_REQUEST_BODY errors from nil values
  - Cleaner codebase without internal workarounds

- **OpenAPI Generator Integration**: Implement custom Mustache templates for OpenAPI Generator
  - Custom templates for api, model, request_builder, and deserializer modules
  - Correct type specifications that pass Dialyzer without warnings
  - Jason encoder/decoder integration replacing Poison
  - Generated code now requires minimal post-processing

- **API Updates**: Regenerate entire API from latest DocuSign OpenAPI specification (August 22, 2025)
  - Uses the most recent spec available from DocuSign's official repository
  - Added new models: ConnectedData, ConnectedObjectDetails, ConnectionInstance, ExtensionData
  - Added new template view models: TemplateViewRecipientSettings, TemplateViewSettings
  - Added recipient preview for template editing
  - Updated all existing API endpoints to latest specifications

### Improvements

- **File Download**: Add `DocuSign.FileDownloader` module for robust file downloads
  - Support for documents, attachments, and any downloadable resources
  - Multiple download strategies: memory, temp file, or specific path
  - Automatic filename extraction from Content-Disposition headers
  - Configurable temp file options with automatic cleanup
  - Content-Type validation and size limits
  - Convenient `Connection.download_file/3` helper function

- **Configuration**: Add auto-detection of OAuth hostname based on base URI
  - `determine_hostname/1` function automatically detects sandbox vs production
  - `detect_environment/1` function identifies environment from base URI
  - `from_oauth_client_with_detection/2` for automatic hostname configuration
  - Eliminates manual hostname configuration in most cases

- **Error Handling**: Add structured error support (opt-in)
  - Set `config :docusign, :structured_errors, true` to enable
  - Provides `DocuSign.Error` struct with detailed error information
  - Backward compatible - defaults to tuple errors

### Bug Fixes

- Fixed OAuth2 client integration to work with Req
- Fixed SSLOptions module to properly configure Finch transport options
- Fixed retry logic initialization when retries are disabled
- Fixed User module warning about is_binary guard
- Updated all API calls to handle Req.Response instead of Tesla.Env

### Internal Changes

- Migrated from Tesla to Req for HTTP client
- Replaced Poison with Jason for JSON handling
- Updated all dependencies to latest versions
- Added comprehensive test coverage for new features
- Improved documentation with more examples

## v2.0.0 (2021-11-11)

### Breaking Changes

- The `private_key` parameter for JWT impersonation has been renamed to `private_key_file`.
  The value is expected to be a file path now.
- Introduced a new `private_key_contents` parameter for JWT impersonation which expects a
  string with the contents of the private key.

### Improvements

- Allow a `private_key_contents` parameter for JWT impersonation, useful for applications
  where the private key is stored in environment variables.
- Introduce `ClientRegistry` which allows using multiple DocuSign accounts in the same application.
- Increased the timeout for `Accounts.refresh_access_token` to account for real-world latencies
- Allow passing in `:ssl_options` per-request to configure SSL with custom CA certificates
- Add example error in docstrings for endpoints that use composite templates
- Added types, docs, specs, and fixed unused variable warnings

### Bug Fixes

- Fixed an issue with newer OAuth library versions where JWT grant parameters
  were incorrectly encoded, causing authentication failures
- Fixed missing alias for `CompositeTemplate` in `Envelopes` module
- Fixed broken refresh token flow that was using wrong token type
- Clarified error messages when OAuth configurations are missing or conflicting

### Internal Changes

- Added dialyzer and resolved all warnings
- Upgraded dependencies to latest versions
- Fixed test async mode for more reliable test runs
- General code cleanup and maintenance

## v1.2.0 (2021-03-25)

### Added

- "JWT Flow for API impersonation added
- Enhanced Test Coverage

## v1.1.0 (2019-09-17)

### Improvements

- Ability to pass options to `Tesla` per request was added

## v1.0.1 (2019-09-06)

### Improvements

- Add support for resending an envelope

## v1.0.0 (2019-07-23)

- Initial public release
