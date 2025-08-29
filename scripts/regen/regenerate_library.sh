#!/bin/bash
# Clean script to regenerate the DocuSign Elixir library using custom templates
# This script properly uses OpenAPI Generator with custom templates (no hacks)

set -e  # Exit on any error

echo "Starting DocuSign Elixir library regeneration with custom templates..."

# Define directories
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "${SCRIPT_DIR}/../.." && pwd )"
TEMP_DIR="${SCRIPT_DIR}/temp"
GEN_DIR="${SCRIPT_DIR}/generated"

# Check for arguments
DOWNLOAD_SPEC=false
GENERATE_CODE=false

for arg in "$@"; do
  case $arg in
    --download)
      DOWNLOAD_SPEC=true
      ;;
    --generate)
      GENERATE_CODE=true
      ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: $0 [--download] [--generate]"
      echo "  --download: Download latest OpenAPI spec"
      echo "  --generate: Force regeneration"
      echo "  (default: use existing spec and generated code if available)"
      exit 1
      ;;
  esac
done

# If no args, check what exists
if [ "$DOWNLOAD_SPEC" = false ] && [ "$GENERATE_CODE" = false ]; then
  if [ ! -f "${TEMP_DIR}/esignature.swagger.json" ]; then
    DOWNLOAD_SPEC=true
  fi
  if [ ! -d "${GEN_DIR}" ] || [ -z "$(ls -A ${GEN_DIR} 2>/dev/null)" ]; then
    GENERATE_CODE=true
  fi
fi

# Create temp directory
mkdir -p "${TEMP_DIR}"

# Download OpenAPI spec if requested or missing
if [ "$DOWNLOAD_SPEC" = true ]; then
  echo "Downloading DocuSign OpenAPI specification..."
  curl -o "${TEMP_DIR}/esignature.swagger.json" \
    "https://raw.githubusercontent.com/docusign/OpenAPI-Specifications/master/esignature.rest.swagger-v2.1.json"
  echo "✅ OpenAPI spec downloaded"
  GENERATE_CODE=true  # Always regenerate after download
fi

# Generate code if requested or after download
if [ "$GENERATE_CODE" = true ]; then
  echo "Generating Elixir client code with custom templates..."

  # Remove old generated directory
  rm -rf "${GEN_DIR}"

  # Generate using OpenAPI Generator with custom templates
  openapi-generator generate \
    -i "${TEMP_DIR}/esignature.swagger.json" \
    -g elixir \
    -o "${GEN_DIR}" \
    -t "${SCRIPT_DIR}/custom_templates" \
    --additional-properties=packageName=docusign_e_signature_restapi,packageVersion="3.0.0",appName="DocuSign",appVersion="3.0.0",moduleName=DocuSign

  echo "✅ Code generation complete"
fi

# Clean up target directories
echo "Cleaning up existing API and model files..."
rm -rf "${PROJECT_ROOT}/lib/docusign/api"
rm -rf "${PROJECT_ROOT}/lib/docusign/model"
mkdir -p "${PROJECT_ROOT}/lib/docusign/api"
mkdir -p "${PROJECT_ROOT}/lib/docusign/model"

# Copy generated files to project
echo "Copying generated files to project..."
cp -r "${GEN_DIR}/lib/docusign_e_signature_restapi/api/"* "${PROJECT_ROOT}/lib/docusign/api/" 2>/dev/null || true
cp -r "${GEN_DIR}/lib/docusign_e_signature_restapi/model/"* "${PROJECT_ROOT}/lib/docusign/model/" 2>/dev/null || true

# Copy core files if they don't exist (but never overwrite connection.ex)
echo "Updating core files..."
for file in deserializer.ex request_builder.ex; do
  src="${GEN_DIR}/lib/docusign_e_signature_restapi/${file}"
  dst="${PROJECT_ROOT}/lib/docusign/${file}"

  if [ -f "$src" ]; then
    # Only copy if destination doesn't exist or is different
    if [ ! -f "$dst" ] || ! cmp -s "$src" "$dst"; then
      echo "  Updating $file..."
      cp "$src" "$dst"
    else
      echo "  $file is up to date"
    fi
  fi
done
# Never overwrite the real DocuSign.Connection module
echo "  Skipping connection.ex (preserving custom implementation)"

# Update module names in all copied files
echo "Updating module names..."
find "${PROJECT_ROOT}/lib/docusign" -type f -name "*.ex" -exec sed -i '' \
  -e 's/DocusignESignatureRESTAPI/DocuSign/g' \
  -e 's/DocuSignESignatureRestapi/DocuSign/g' \
  -e 's/docusign_e_signature_restapi/docusign/g' {} \;

# Format the code
echo "Formatting code..."
cd "${PROJECT_ROOT}" && mix format

# Run Dialyzer to check types
echo "Running Dialyzer to check type specifications..."
cd "${PROJECT_ROOT}" && mix dialyzer

# Run tests
echo "Running tests to verify changes..."
cd "${PROJECT_ROOT}" && mix test

echo "✅ Regeneration complete!"
echo ""
echo "Summary:"
echo "- Used custom templates from ${SCRIPT_DIR}/custom_templates"
echo "- Generated code with proper Req.Response types"
echo "- All tests passing"
echo ""
echo "Usage:"
echo "  $0                # Use existing spec and generated code if available"
echo "  $0 --download     # Download latest spec and regenerate"
echo "  $0 --generate     # Force regeneration from existing spec"
