# DocuSign Elixir Library Regeneration

This directory contains scripts and custom templates for regenerating the DocuSign Elixir library from the OpenAPI specification.

## Prerequisites

Before running the scripts, ensure:

1. You have the [OpenAPI Generator](https://openapi-generator.tech/docs/installation) installed (version 7.0.0 or later)
2. Java runtime environment (required by OpenAPI Generator)
3. A working Elixir development environment

## Quick Start

The regeneration script handles everything automatically:

```bash
cd scripts/regen
./regenerate_library.sh
```

This will:

1. Use the tracked OpenAPI specification in `esignature-rest-api-v2.1.json`
2. Generate the client code using our custom Mustache templates
3. Apply necessary post-processing (module naming, formatting)
4. Run tests to verify everything works

## Templates

The Req-based Elixir client is now upstream in OpenAPI Generator, selected with
`--library=req` (added in PRs
[#24840](https://github.com/OpenAPITools/openapi-generator/pull/24840) and
[#24841](https://github.com/OpenAPITools/openapi-generator/pull/24841), shipping
in 7.26.0). The API, request builder, deserializer and connection templates all
come from upstream, so they are no longer vendored here.

`custom_templates/` therefore holds a single override:

- `model.mustache` — upstream's model template with one change: generated models
  omit nil fields when encoding instead of deriving `JSON.Encoder` directly.
  DocuSign treats an explicit `null` as "clear this field" and its models are very
  wide (`EnvelopeDefinition` has 90 fields, `Signer` 101), so serializing unset
  fields as `null` would both bloat requests and risk wiping data on updates.

Everything else resolves from the generator's built-in templates.

**The regeneration script requires OpenAPI Generator 7.26.0 or newer** and fails
early on older releases, which would silently fall back to the Tesla templates.

Templates included:

- `api.mustache` - API module generation
- `model.mustache` - Model struct generation
- `request_builder.mustache` - Request building logic
- `deserializer.mustache` - Response deserialization

## Script Options

- `./regenerate_library.sh` - Regenerate from the tracked specification
- `./regenerate_library.sh --download` - Download the latest spec into the tracked specification, then regenerate

The generated directory is cleaned before every generation. The tracked
specification is never replaced unless `--download` is explicitly provided.

## What Gets Generated

The script regenerates:

- `lib/docusign/api/*.ex` - All API endpoint modules
- `lib/docusign/model/*.ex` - All model/struct modules
- Updates to RequestBuilder and Deserializer modules

## What's Preserved

These files are NOT regenerated and contain our customizations:

- `lib/docusign/connection.ex` - Connection management and retry logic
- `lib/docusign/file_downloader.ex` - File download functionality
- `lib/docusign/telemetry.ex` - Telemetry integration
- `lib/docusign/webhook_plug.ex` - Webhook handling
- All test files
- All documentation

## Post-Processing

After generation, the script automatically:

1. Fixes module naming (from OpenAPIDocusignEsignRestV21 to DocuSign)
2. Ensures all files pass `mix format`
3. Runs the test suite to verify compatibility

## Notes

- The custom templates eliminate the need for ModelCleaner (Req handles nil values properly)
- Generated code requires minimal manual intervention
- Tests should pass immediately after regeneration
- With `--download`, the latest spec is downloaded from: https://github.com/docusign/OpenAPI-Specifications

## Troubleshooting

If you encounter issues:

1. Ensure OpenAPI Generator is installed: `openapi-generator-cli version`
2. Check Java is available: `java -version`
3. Review the generated files in `generated/` before they're copied
4. Check test failures for specific compatibility issues
