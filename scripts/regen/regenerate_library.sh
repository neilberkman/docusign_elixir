#!/bin/bash
# Script to regenerate the DocuSign Elixir library while preserving custom files

set -e  # Exit on any error

echo "Starting DocuSign Elixir library regeneration..."

# Define directories using relative paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCUSIGN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
PRESERVE_DIR="${SCRIPT_DIR}/preserved"
TEMP_DIR="/tmp/docusign_regen"
GEN_DIR="${TEMP_DIR}/elixir_api_client"

# Check if OpenAPI spec exists
if [ ! -f "${TEMP_DIR}/esignature.swagger.json" ]; then
  echo "ERROR: OpenAPI specification not found at ${TEMP_DIR}/esignature.swagger.json"
  echo "Please download the specification first:"
  echo "curl -o /tmp/docusign_regen/esignature.swagger.json https://raw.githubusercontent.com/docusign/eSign-OpenAPI-Specification/master/esignature.rest.swagger-v2.1.json"
  exit 1
fi

# Check if OpenAPI generator has been run
if [ ! -d "${GEN_DIR}" ]; then
  echo "ERROR: Generated code not found at ${GEN_DIR}"
  echo "Please generate the client first:"
  echo "openapi-generator generate -i /tmp/docusign_regen/esignature.swagger.json -g elixir -o /tmp/docusign_regen/elixir_api_client --additional-properties=packageName=docusign_e_signature_restapi"
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

echo "Running tests to verify changes..."
cd "${DOCUSIGN_DIR}" && mix test || echo "⚠️ Tests failed! Please review the changes."

echo "✅ Regeneration complete!"
echo "Please review the changes and make any necessary adjustments."
