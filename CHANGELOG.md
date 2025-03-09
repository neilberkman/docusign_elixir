# Changelog

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
or `:private_key_contents`.
    - `:private_key_file` accepts a file path to the private key, exactly like
      `:private_key`.
    - `:private_key_contents` is the contents of the private key, typically
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
