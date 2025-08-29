#!/bin/bash
# Improved script to regenerate the DocuSign Elixir library with automatic type fixes
# This version automatically fixes the Tesla.Env.client() type specification issue

set -e  # Exit on any error

echo "Starting improved DocuSign Elixir library regeneration..."

# Define directories using relative paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCUSIGN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
PRESERVE_DIR="${SCRIPT_DIR}/preserved"
TEMP_DIR="/tmp/docusign_regen"
GEN_DIR="${TEMP_DIR}/elixir_api_client"

# Create temp directory if it doesn't exist
mkdir -p "${TEMP_DIR}"

# Download latest OpenAPI spec if not present or if requested
if [ "$1" == "--download" ] || [ ! -f "${TEMP_DIR}/esignature.swagger.json" ]; then
  echo "Downloading latest DocuSign OpenAPI specification..."
  curl -o "${TEMP_DIR}/esignature.swagger.json" \
    https://raw.githubusercontent.com/docusign/OpenAPI-Specifications/master/esignature.rest.swagger-v2.1.json
  echo "Download complete!"
fi

# Check if OpenAPI spec exists
if [ ! -f "${TEMP_DIR}/esignature.swagger.json" ]; then
  echo "ERROR: OpenAPI specification not found at ${TEMP_DIR}/esignature.swagger.json"
  echo "Run with --download flag or manually download the specification"
  exit 1
fi

# Generate client code if not present or if requested
if [ "$1" == "--generate" ] || [ "$1" == "--download" ] || [ ! -d "${GEN_DIR}" ]; then
  echo "Generating Elixir client code..."
  openapi-generator generate \
    -i "${TEMP_DIR}/esignature.swagger.json" \
    -g elixir \
    -o "${GEN_DIR}" \
    --additional-properties=packageName=docusign_e_signature_restapi
  echo "Generation complete!"
fi

# Check if generated code exists
if [ ! -d "${GEN_DIR}" ]; then
  echo "ERROR: Generated code not found at ${GEN_DIR}"
  echo "Run with --generate flag to generate the client code"
  exit 1
fi

# Create backup and preserve directories
mkdir -p "${PRESERVE_DIR}"
mkdir -p "${DOCUSIGN_DIR}/backup/api"
mkdir -p "${DOCUSIGN_DIR}/backup/model"

# List of files to preserve
PRESERVE_FILES=(
  "lib/docusign/model_cleaner.ex"
  "lib/docusign/model_cleaner_jason.ex"
  "lib/docusign/model/recipient_view_url.ex"
  "test/docusign/model_cleaner_test.exs"
  "test/docusign/model_cleaner_jason_test.exs"
  "test/docusign/model_cleaner_integration_test.exs"
)

# Preserve custom files
echo "Backing up custom files..."
for file in "${PRESERVE_FILES[@]}"; do
  if [ -f "${DOCUSIGN_DIR}/${file}" ]; then
    echo "- Preserving ${file}"
    cp "${DOCUSIGN_DIR}/${file}" "${PRESERVE_DIR}/$(basename "${file}")"
  fi
done

# Backup existing API and model files
echo "Backing up existing API and model files..."
cp -r "${DOCUSIGN_DIR}/lib/docusign/api/"* "${DOCUSIGN_DIR}/backup/api/" 2>/dev/null || true
cp -r "${DOCUSIGN_DIR}/lib/docusign/model/"* "${DOCUSIGN_DIR}/backup/model/" 2>/dev/null || true

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

# FIX: Update type specifications to use DocuSign.Connection.t() instead of Tesla.Env.client()
echo "Fixing type specifications to use DocuSign.Connection.t()..."
find "${DOCUSIGN_DIR}/lib/docusign/api" -name "*.ex" -exec sed -i '' 's/Tesla\.Env\.client()/DocuSign.Connection.t()/g' {} \;

# Ensure models use Jason
echo "Ensuring models use Jason.Encoder..."
find "${DOCUSIGN_DIR}/lib/docusign/model" -name "*.ex" -exec sed -i '' 's/@derive \[Poison\.Encoder\]/@derive [Jason.Encoder]/g' {} \;
find "${DOCUSIGN_DIR}/lib/docusign/model" -name "*.ex" -exec sed -i '' 's/defimpl Poison\.Decoder/defimpl Jason.Decoder/g' {} \;

# Update core files to use Jason
echo "Updating core files to use Jason..."
if [ -f "${DOCUSIGN_DIR}/lib/docusign/request_builder.ex" ]; then
  sed -i '' 's/Poison\.encode!/Jason.encode!/g' "${DOCUSIGN_DIR}/lib/docusign/request_builder.ex"
fi
if [ -f "${DOCUSIGN_DIR}/lib/docusign/deserializer.ex" ]; then
  sed -i '' 's/Poison\.decode!/Jason.decode!/g' "${DOCUSIGN_DIR}/lib/docusign/deserializer.ex"
fi

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

# Modify request_builder.ex to integrate ModelCleaner
echo "Integrating ModelCleaner with request_builder.ex..."
sed -i '' '/def add_param(request, :body, :body, value)/c\
  def add_param(request, :body, :body, value) do\
    # Clean the value using ModelCleaner\
    cleaned_value = DocuSign.ModelCleaner.clean(value)\
    Map.put(request, :body, cleaned_value)\
  end' "${DOCUSIGN_DIR}/lib/docusign/request_builder.ex"

sed -i '' '/def add_param(request, :body, key, value)/,+8c\
  def add_param(request, :body, key, value) do\
    # Clean the value using ModelCleaner before encoding with Jason\
    cleaned_value = DocuSign.ModelCleaner.clean(value)\
\
    request\
    |> Map.put_new_lazy(:body, \&Tesla.Multipart.new/0)\
    |> Map.update!(:body, fn multipart ->\
      Tesla.Multipart.add_field(\
        multipart,\
        key,\
        Jason.encode!(cleaned_value),\
        headers: [{:"Content-Type", "application/json"}]\
      )\
    end)\
  end' "${DOCUSIGN_DIR}/lib/docusign/request_builder.ex"

# Format and test code
echo "Formatting code..."
cd "${DOCUSIGN_DIR}" && mix format

echo "Running Dialyzer to check type specifications..."
cd "${DOCUSIGN_DIR}" && mix dialyzer || echo "⚠️ Dialyzer found issues! Please review."

echo "Running tests to verify changes..."
cd "${DOCUSIGN_DIR}" && mix test || echo "⚠️ Tests failed! Please review the changes."

echo "✅ Improved regeneration complete!"
echo ""
echo "Summary of improvements:"
echo "- Automatically fixed type specifications (Tesla.Env.client() → DocuSign.Connection.t())"
echo "- Updated to use latest OpenAPI specification URL"
echo "- Integrated Jason instead of Poison"
echo "- Preserved custom files and ModelCleaner integration"
echo ""
echo "Usage:"
echo "  ./improved_regenerate_library.sh           # Use existing downloaded spec and generated code"
echo "  ./improved_regenerate_library.sh --download # Download latest spec and regenerate"
echo "  ./improved_regenerate_library.sh --generate # Regenerate from existing spec"
