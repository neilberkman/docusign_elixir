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
SPEC_FILE="${SCRIPT_DIR}/esignature-rest-api-v2.1.json"

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

# The Elixir generator only grew the Req client (--library=req) after 7.25.0.
# Earlier versions silently fall back to the Tesla templates, which would
# produce a client that does not match this library's hand-written code.
mkdir -p "${TEMP_DIR}"
GENERATOR_VERSION="$(cd "${TEMP_DIR}" && ${OPENAPI_CMD} version 2>/dev/null | tail -1 | tr -d '[:space:]')"
REQUIRED_VERSION="7.26.0"
if [ -n "${GENERATOR_VERSION}" ] && [ "${GENERATOR_VERSION%-SNAPSHOT}" = "${GENERATOR_VERSION}" ]; then
  OLDEST="$(printf '%s\n%s\n' "${REQUIRED_VERSION}" "${GENERATOR_VERSION}" | sort -V | head -1)"
  if [ "${OLDEST}" != "${REQUIRED_VERSION}" ]; then
    echo "ERROR: OpenAPI Generator ${GENERATOR_VERSION} is too old."
    echo "       This library generates the Req client via --library=req, which"
    echo "       landed after 7.25.0 (PRs #24840 and #24841) and ships in ${REQUIRED_VERSION}."
    echo "       Upgrade the generator, or pin a ${REQUIRED_VERSION}-SNAPSHOT build."
    exit 1
  fi
fi

# Parse command line arguments
FORCE_DOWNLOAD=false

for arg in "$@"; do
  case $arg in
    --download)
      FORCE_DOWNLOAD=true
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --download    Download the latest OpenAPI spec into the tracked spec file"
      echo "  --help        Show this help message"
      exit 0
      ;;
    *)
      echo "ERROR: Unknown option: $arg"
      exit 1
      ;;
  esac
done

# Download OpenAPI spec if requested
if [ "$FORCE_DOWNLOAD" = true ]; then
  echo "Downloading latest OpenAPI specification from DocuSign..."
  # Using the official DocuSign OpenAPI Specifications repository
  curl -L -o "${SPEC_FILE}" \
    "https://raw.githubusercontent.com/docusign/OpenAPI-Specifications/master/esignature.rest.swagger-v2.1.json" || {
    echo "ERROR: Failed to download OpenAPI spec"
    exit 1
  }
  echo "✓ OpenAPI spec downloaded"
fi

echo "Cleaning generated directory..."
mkdir -p "${TEMP_DIR}"
rm -rf "${GEN_DIR}"

echo "Generating client code with custom templates..."
(cd "${TEMP_DIR}" && ${OPENAPI_CMD} generate \
  -i "${SPEC_FILE}" \
  -g elixir \
  -t "${CUSTOM_TEMPLATES}" \
  -o "${GEN_DIR}" \
  --additional-properties=packageName=docusign \
  --additional-properties=invokerPackage=DocuSign \
  --additional-properties=library=req) || {
  echo "ERROR: Code generation failed"
  exit 1
}
echo "✓ Code generated successfully"

# Check that generation produced expected files
# The invokerPackage option makes the generator create files under docu_sign.
if [ ! -d "${GEN_DIR}/lib/docu_sign/api" ]; then
  echo "ERROR: Generated code not found at expected location"
  echo "Looking for: ${GEN_DIR}/lib/docu_sign/api"
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
cp -r "${GEN_DIR}/lib/docu_sign/api/"*.ex "${DOCUSIGN_DIR}/lib/docusign/api/"

echo "Copying new model files..."
cp -r "${GEN_DIR}/lib/docu_sign/model/"*.ex "${DOCUSIGN_DIR}/lib/docusign/model/"

# Copy core files (RequestBuilder and Deserializer)
echo "Updating core files..."
cp "${GEN_DIR}/lib/docu_sign/request_builder.ex" "${DOCUSIGN_DIR}/lib/docusign/request_builder.ex"
cp "${GEN_DIR}/lib/docu_sign/deserializer.ex" "${DOCUSIGN_DIR}/lib/docusign/deserializer.ex"

# Apply any post-processing fixes if needed
echo "Applying post-processing..."

# Bridge until the upstream generator encodes path parameters itself.
# Match only bare variables, so already-encoded interpolations stay unchanged.
perl -0pi -e 's{(\|> url\(\s*"[^"]*")}{my $url = $1; $url =~ s/#\{([a-z][a-z0-9_]*)\}/#{encode_path_param($1)}/g; $url}ge' \
  "${DOCUSIGN_DIR}/lib/docusign/api/"*.ex

# Fix any lingering module name issues (shouldn't be needed with correct templates)
find "${DOCUSIGN_DIR}/lib/docusign" -name "*.ex" -exec grep -l "DocusignESignatureRESTAPI" {} \; | while read file; do
  echo "  Fixing module name in $(basename $file)"
  perl -pi -e 's/DocusignESignatureRESTAPI/DocuSign/g' "$file"
done

# Convert DocuSign developer-site links from root-relative paths to absolute URLs.
find "${DOCUSIGN_DIR}/lib/docusign/api" "${DOCUSIGN_DIR}/lib/docusign/model" -name "*.ex" -exec perl -0pi -e \
  's{(?<![A-Za-z0-9.])/docs/}{https://developers.docusign.com/docs/}g; s{(?<![A-Za-z0-9.])/platform/}{https://developers.docusign.com/platform/}g' {} +

# Remove trailing whitespace copied from the OpenAPI descriptions.
find "${DOCUSIGN_DIR}/lib/docusign/api" "${DOCUSIGN_DIR}/lib/docusign/model" -name "*.ex" -exec perl -0pi -e 's/[ \t]+$//mg' {} +

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
