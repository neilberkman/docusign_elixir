# DocuSign Elixir Library Regeneration

This directory contains scripts and resources for regenerating the DocuSign Elixir library from the OpenAPI specification.

## Prerequisites

Before running the scripts, ensure:

1. You have the [OpenAPI Generator](https://openapi-generator.tech/docs/installation) installed
2. Download the latest [DocuSign OpenAPI Specification](https://raw.githubusercontent.com/docusign/eSign-OpenAPI-Specification/master/esignature.rest.swagger-v2.1.json) file
3. A working Elixir development environment

## Using the Regeneration Scripts

### Quick Start

The regeneration script handles everything automatically:

```bash
cd scripts/regen
./regenerate_library.sh
```

This will:

1. Download the latest OpenAPI specification (if not present)
2. Generate the client code with custom templates
3. Update the library while preserving customizations
4. Run tests to verify everything works

### Options

- `./regenerate_library.sh` - Use cached spec and generated code if available
- `./regenerate_library.sh --download` - Force download latest spec and regenerate
- `./regenerate_library.sh --generate` - Force regeneration using existing spec

## Script Details

### regenerate_library.sh

This script:

1. Backs up custom files to be preserved (ModelCleaner, tests, etc.)
2. Backs up existing API and model files
3. Copies new API and model files from the generated code
4. Updates module names (from DocusignESignatureRESTAPI to DocuSign)
5. Updates JSON handling from Poison to Jason
6. Restores preserved custom files
7. Integrates ModelCleanerJason for nil value removal with Jason
8. Updates mix.exs dependencies
9. Formats code and runs tests

### Features Preserved

- **ModelCleaner functionality**: Ensures nil values are stripped from nested request bodies
- **RecipientViewUrl model**: For embedded signing responses
- **Tests**: Preserves existing tests and updates them for Jason

## Notes

- The scripts modify the generated code to maintain backward compatibility
- The modernized script migrates from Poison to Jason for JSON handling
- Tests are run at the end to verify everything works as expected

## Troubleshooting

If you encounter issues:

1. Check the backup directories for original files
2. Review the CHANGES-JASON.md file for details on the JSON library migration
3. Check test failures for specific issues
