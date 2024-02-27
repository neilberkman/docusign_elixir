# Changelog

## v1.2.0 (unreleased)

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
