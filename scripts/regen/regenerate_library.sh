#!/bin/bash
# Script to regenerate the DocuSign Elixir library from OpenAPI spec using custom templates
# This preserves hand-written code while regenerating API and model files

set -e  # Exit on any error

echo "Starting DocuSign Elixir library regeneration..."

# Define directories
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCUSIGN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMP_DIR="/tmp/docusign_regen"
GEN_DIR="${TEMP_DIR}/generated"

# Check if custom templates exist
CUSTOM_TEMPLATES="${SCRIPT_DIR}/custom_templates"
if [ ! -d "${CUSTOM_TEMPLATES}" ]; then
  echo "ERROR: Custom templates not found at ${CUSTOM_TEMPLATES}"
  exit 1
fi

# Check for OpenAPI Generator
if ! command -v openapi-generator-cli &> /dev/null && ! command -v openapi-generator &> /dev/null; then
  echo "ERROR: OpenAPI Generator is not installed"
  echo "Install it from: https://openapi-generator.tech/docs/installation"
  exit 1
fi

# Determine which command to use
if command -v openapi-generator-cli &> /dev/null; then
  OPENAPI_CMD="openapi-generator-cli"
else
  OPENAPI_CMD="openapi-generator"
fi

# Parse command line arguments
FORCE_DOWNLOAD=false
FORCE_GENERATE=false
CLEAN_FIRST=false

for arg in "$@"; do
  case $arg in
    --download)
      FORCE_DOWNLOAD=true
      FORCE_GENERATE=true
      ;;
    --generate)
      FORCE_GENERATE=true
      ;;
    --clean)
      CLEAN_FIRST=true
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --download    Force download latest OpenAPI spec and regenerate"
      echo "  --generate    Force regeneration using existing spec"
      echo "  --clean       Clean generated directory before generating"
      echo "  --help        Show this help message"
      exit 0
      ;;
  esac
done

# Create temp directory if it doesn't exist
mkdir -p "${TEMP_DIR}"

# Download OpenAPI spec if needed
SPEC_FILE="${TEMP_DIR}/esignature.swagger.json"
if [ ! -f "${SPEC_FILE}" ] || [ "$FORCE_DOWNLOAD" = true ]; then
  echo "Downloading latest OpenAPI specification from DocuSign..."
  # Using the official DocuSign OpenAPI Specifications repository
  curl -L -o "${SPEC_FILE}" \
    "https://raw.githubusercontent.com/docusign/OpenAPI-Specifications/master/esignature.rest.swagger-v2.1.json" || {
    echo "ERROR: Failed to download OpenAPI spec"
    exit 1
  }
  echo "✓ OpenAPI spec downloaded"
fi

# Clean generated directory if requested
if [ "$CLEAN_FIRST" = true ] && [ -d "${GEN_DIR}" ]; then
  echo "Cleaning generated directory..."
  rm -rf "${GEN_DIR}"
fi

# Generate the client code if needed
if [ ! -d "${GEN_DIR}" ] || [ "$FORCE_GENERATE" = true ]; then
  echo "Generating client code with custom templates..."
  ${OPENAPI_CMD} generate \
    -i "${SPEC_FILE}" \
    -g elixir \
    -t "${CUSTOM_TEMPLATES}" \
    -o "${GEN_DIR}" \
    --additional-properties=packageName=docusign \
    --additional-properties=moduleName=DocuSign || {
    echo "ERROR: Code generation failed"
    exit 1
  }
  echo "✓ Code generated successfully"
fi

# Check that generation produced expected files
# The generator creates files under docusign_e_signature_restapi by default
if [ ! -d "${GEN_DIR}/lib/docusign_e_signature_restapi/api" ]; then
  echo "ERROR: Generated code not found at expected location"
  echo "Looking for: ${GEN_DIR}/lib/docusign_e_signature_restapi/api"
  exit 1
fi

# Backup existing files (optional, for safety)
BACKUP_DIR="${TEMP_DIR}/backup_$(date +%Y%m%d_%H%M%S)"
echo "Creating backup of existing files at ${BACKUP_DIR}..."
mkdir -p "${BACKUP_DIR}"
cp -r "${DOCUSIGN_DIR}/lib/docusign/api" "${BACKUP_DIR}/" 2>/dev/null || true
cp -r "${DOCUSIGN_DIR}/lib/docusign/model" "${BACKUP_DIR}/" 2>/dev/null || true
echo "✓ Backup created"

# Clean out existing generated files
echo "Removing old API and model files..."
rm -rf "${DOCUSIGN_DIR}/lib/docusign/api/"*.ex
rm -rf "${DOCUSIGN_DIR}/lib/docusign/model/"*.ex

# Copy new generated files from the actual generated paths
echo "Copying new API files..."
cp -r "${GEN_DIR}/lib/docusign_e_signature_restapi/api/"*.ex "${DOCUSIGN_DIR}/lib/docusign/api/"

echo "Copying new model files..."
cp -r "${GEN_DIR}/lib/docusign_e_signature_restapi/model/"*.ex "${DOCUSIGN_DIR}/lib/docusign/model/"

# Copy core files (RequestBuilder and Deserializer)
echo "Updating core files..."
cp "${GEN_DIR}/lib/docusign_e_signature_restapi/request_builder.ex" "${DOCUSIGN_DIR}/lib/docusign/request_builder.ex"
cp "${GEN_DIR}/lib/docusign_e_signature_restapi/deserializer.ex" "${DOCUSIGN_DIR}/lib/docusign/deserializer.ex"

# Apply any post-processing fixes if needed
echo "Applying post-processing..."

# Fix any lingering module name issues (shouldn't be needed with correct templates)
find "${DOCUSIGN_DIR}/lib/docusign" -name "*.ex" -exec grep -l "DocusignESignatureRESTAPI" {} \; | while read file; do
  echo "  Fixing module name in $(basename $file)"
  sed -i '' 's/DocusignESignatureRESTAPI/DocuSign/g' "$file"
done

# Ensure correct JSON library (should already be Jason from templates)
find "${DOCUSIGN_DIR}/lib/docusign/model" -name "*.ex" -exec grep -l "Poison" {} \; | while read file; do
  echo "  Fixing JSON library in $(basename $file)"
  sed -i '' 's/@derive \[Poison\.Encoder\]/@derive [Jason.Encoder]/g' "$file"
  sed -i '' 's/Poison\./Jason./g' "$file"
done

# Format all generated code
echo "Formatting generated code..."
cd "${DOCUSIGN_DIR}"
mix format lib/docusign/api/*.ex lib/docusign/model/*.ex lib/docusign/request_builder.ex lib/docusign/deserializer.ex

# Run tests to verify
echo "Running tests to verify regeneration..."
mix test || {
  echo ""
  echo "⚠️  Tests failed! This might be expected if the API has breaking changes."
  echo "    Please review the test failures and update as needed."
  echo ""
  echo "    Backup of original files saved at: ${BACKUP_DIR}"
}

echo ""
echo "✅ Regeneration complete!"
echo ""
echo "Next steps:"
echo "1. Review the changes with: git diff"
echo "2. Run tests with: mix test"
echo "3. Update any failing tests if the API changed"
echo "4. Commit the changes"
echo ""
echo "Note: Hand-written files (Connection, FileDownloader, Telemetry, etc.) were preserved."
