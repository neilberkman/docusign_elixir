#!/bin/bash
# Script to regenerate the DocuSign Elixir library while preserving custom files

set -e  # Exit on any error

echo "Starting DocuSign Elixir library regeneration..."

# Define directories using relative paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCUSIGN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
PRESERVE_DIR="${SCRIPT_DIR}/preserved"
TEMP_DIR="/tmp/docusign_regen"
GEN_DIR="${TEMP_DIR}/custom_gen"

# Check if custom templates exist
CUSTOM_TEMPLATES="${SCRIPT_DIR}/custom_templates"
if [ ! -d "${CUSTOM_TEMPLATES}" ]; then
  echo "ERROR: Custom templates not found at ${CUSTOM_TEMPLATES}"
  exit 1
fi

# Create temp directory if it doesn't exist
mkdir -p "${TEMP_DIR}"

# Download OpenAPI spec if not present or if --download flag is passed
if [ ! -f "${TEMP_DIR}/esignature.swagger.json" ] || [ "$1" == "--download" ]; then
  echo "Downloading latest OpenAPI specification..."
  curl -o "${TEMP_DIR}/esignature.swagger.json" https://raw.githubusercontent.com/docusign/eSign-OpenAPI-Specification/master/esignature.rest.swagger-v2.1.json
fi

# Generate the client code if not present or if --generate flag is passed
if [ ! -d "${GEN_DIR}" ] || [ "$1" == "--generate" ] || [ "$1" == "--download" ]; then
  echo "Generating client code with custom templates..."
  openapi-generator generate \
    -i "${TEMP_DIR}/esignature.swagger.json" \
    -g elixir \
    -t "${CUSTOM_TEMPLATES}" \
    -o "${GEN_DIR}" \
    --additional-properties=packageName=docusign_e_signature_restapi
fi

# Create preserve directory
mkdir -p "${PRESERVE_DIR}"

# List of files to preserve
PRESERVE_FILES=(
  "lib/docusign/model/recipient_view_url.ex"
)

# Preserve custom files
echo "Backing up custom files..."
for file in "${PRESERVE_FILES[@]}"; do
  if [ -f "${DOCUSIGN_DIR}/${file}" ]; then
    echo "- Preserving ${file}"
    cp "${DOCUSIGN_DIR}/${file}" "${PRESERVE_DIR}/$(basename "${file}")"
  fi
done


# Clean out existing files
echo "Removing old API and model files..."
rm -rf "${DOCUSIGN_DIR}/lib/docusign/api/"*
rm -rf "${DOCUSIGN_DIR}/lib/docusign/model/"*

# Copy new generated files
echo "Copying new API and model files..."
cp -r "${GEN_DIR}/lib/docusign_e_signature_restapi/api/"* "${DOCUSIGN_DIR}/lib/docusign/api/"
cp -r "${GEN_DIR}/lib/docusign_e_signature_restapi/model/"* "${DOCUSIGN_DIR}/lib/docusign/model/"

# Copy and modify core files
echo "Copying core files with module name adjustments..."
sed 's/DocusignESignatureRESTAPI/DocuSign/g' "${GEN_DIR}/lib/docusign_e_signature_restapi/request_builder.ex" > "${DOCUSIGN_DIR}/lib/docusign/request_builder.ex"
sed 's/DocusignESignatureRESTAPI/DocuSign/g' "${GEN_DIR}/lib/docusign_e_signature_restapi/deserializer.ex" > "${DOCUSIGN_DIR}/lib/docusign/deserializer.ex"

# Update module names in files
echo "Updating module names in API files..."
find "${DOCUSIGN_DIR}/lib/docusign/api" -name "*.ex" -exec sed -i '' 's/DocusignESignatureRESTAPI/DocuSign/g' {} \;

echo "Updating module names in model files..."
find "${DOCUSIGN_DIR}/lib/docusign/model" -name "*.ex" -exec sed -i '' 's/DocusignESignatureRESTAPI/DocuSign/g' {} \;

# Ensure models use Jason
echo "Ensuring models use Jason.Encoder..."
find "${DOCUSIGN_DIR}/lib/docusign/model" -name "*.ex" -exec sed -i '' 's/@derive \[Poison\.Encoder\]/@derive [Jason.Encoder]/g' {} \;
find "${DOCUSIGN_DIR}/lib/docusign/model" -name "*.ex" -exec sed -i '' 's/defimpl Poison\.Decoder/defimpl Jason.Decoder/g' {} \;

# Restore preserved files
echo "Restoring preserved custom files..."
for file in "${PRESERVE_DIR}/"*; do
  base=$(basename "${file}")
  if [[ "${base}" == "recipient_view_url.ex" ]]; then
    echo "- Restoring model/${base}"
    cp "${file}" "${DOCUSIGN_DIR}/lib/docusign/model/"
  elif [[ "${base}" == *_test.exs ]]; then
    echo "- Restoring test/docusign/${base}"
    cp "${file}" "${DOCUSIGN_DIR}/test/docusign/"
  else
    echo "- Restoring lib/docusign/${base}"
    cp "${file}" "${DOCUSIGN_DIR}/lib/docusign/"
  fi
done

# Custom templates already include ModelCleaner integration
echo "Custom templates include ModelCleaner integration..."

# Format and test code
echo "Formatting code..."
cd "${DOCUSIGN_DIR}" && mix format

echo "Running tests to verify changes..."
cd "${DOCUSIGN_DIR}" && mix test || echo "⚠️ Tests failed! Please review the changes."

echo "✅ Regeneration complete!"
echo "Please review the changes and make any necessary adjustments."
