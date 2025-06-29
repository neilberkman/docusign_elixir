# DocuSign Elixir Library Regeneration

This directory contains scripts and resources for regenerating the DocuSign Elixir library from the OpenAPI specification.

## Prerequisites

Before running the scripts, ensure:

1. You have the [OpenAPI Generator](https://openapi-generator.tech/docs/installation) installed
2. Download the latest [DocuSign OpenAPI Specification](https://raw.githubusercontent.com/docusign/eSign-OpenAPI-Specification/master/esignature.rest.swagger-v2.1.json) file
3. A working Elixir development environment

## Using the Regeneration Scripts

### Complete Process

For a complete regeneration, follow these steps:

1. Download the latest specification:
```bash
curl -o esignature.swagger.json https://raw.githubusercontent.com/docusign/eSign-OpenAPI-Specification/master/esignature.rest.swagger-v2.1.json
```

2. Generate the API client code:
```bash
openapi-generator generate \
  -i esignature.swagger.json \
  -g elixir \
  -o /tmp/docusign_regen/elixir_api_client \
  --additional-properties=packageName=docusign_e_signature_restapi
```

3. Run the modernized regeneration script:
```bash
cd scripts/regen
chmod +x modernized_regenerate_library.sh
./modernized_regenerate_library.sh
```

## Available Scripts

1. `regenerate_library.sh` - Basic regeneration script (original)
2. `enhanced_regenerate_library.sh` - Preserves the ModelCleaner while regenerating
3. `modernized_regenerate_library.sh` - Updates to use Jason instead of Poison and preserves ModelCleaner

## Script Details

### modernized_regenerate_library.sh

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
