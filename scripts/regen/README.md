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

1. Download the latest OpenAPI specification from DocuSign's official repository
2. Generate the client code using our custom Mustache templates
3. Apply necessary post-processing (module naming, formatting)
4. Run tests to verify everything works

## Custom Templates

The `custom_templates/` directory contains our customized Mustache templates that produce:

- Proper Elixir module naming conventions
- Correct type specifications that pass Dialyzer
- Jason encoder/decoder integration (replacing Poison)
- Req.Response types instead of Tesla.Env
- Clean, formatted code that passes `mix format`

Templates included:

- `api.mustache` - API module generation
- `model.mustache` - Model struct generation
- `request_builder.mustache` - Request building logic
- `deserializer.mustache` - Response deserialization

## Script Options

- `./regenerate_library.sh` - Standard regeneration
- `./regenerate_library.sh --download` - Force download latest spec
- `./regenerate_library.sh --clean` - Clean all generated files first

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
- The latest spec is downloaded from: https://github.com/docusign/OpenAPI-Specifications

## Troubleshooting

If you encounter issues:

1. Ensure OpenAPI Generator is installed: `openapi-generator-cli version`
2. Check Java is available: `java -version`
3. Review the generated files in `generated/` before they're copied
4. Check test failures for specific compatibility issues
