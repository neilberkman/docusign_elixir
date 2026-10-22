# DocuSign Elixir Library Regeneration

This directory contains scripts and custom templates for regenerating the DocuSign Elixir library from the OpenAPI specification.

## Prerequisites

Before running the scripts, ensure:

1. You have the [OpenAPI Generator](https://openapi-generator.tech/docs/installation) installed (version 7.26.0 or later)
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

`custom_templates/` holds the complete Elixir template set, laid out the way
OpenAPI Generator 7.26.0 expects for `--library=req`. Two things force the full
set to be vendored rather than a single override:

- The generator's `-t` fallback is broken for Elixir. `ElixirClientCodegen` sets
  `templateDir` but never `embeddedTemplateDir`, so a custom template directory
  replaces the embedded lookup location instead of layering on it, and any
  template missing from `-t` fails with `TemplateNotFoundException`. An upstream
  fix is in progress; until it ships in a release, every template has to be
  present here.
- The generated code in `lib/docusign/api`, `request_builder.ex` and
  `deserializer.ex` was produced from the Req templates this library carried
  before they were upstreamed (PRs
  [#24840](https://github.com/OpenAPITools/openapi-generator/pull/24840) and
  [#24841](https://github.com/OpenAPITools/openapi-generator/pull/24841)).
  Upstream's merged versions differ (header serialization, multipart handling,
  the shared Deserializer API), and regenerating from them changes runtime
  behaviour and fails eight tests. The vendored `libraries/req/api.mustache`,
  `libraries/req/request_builder.ex.mustache`, `deserializer.ex.mustache` and
  `model.mustache` are therefore the pre-upstream versions, so the script
  reproduces the committed code byte for byte. Moving to upstream's templates is
  a separate change that needs those tests and the hand-written code reviewed
  together.

On top of that, three local deviations:

- `model.mustache` omits nil fields when encoding instead of deriving
  `JSON.Encoder` directly. DocuSign treats an explicit `null` as "clear this
  field" and its models are wide (`EnvelopeDefinition` has 90 fields, `Signer`
  101), so serializing unset fields as `null` would bloat requests and risk
  wiping data on updates.
- `libraries/req/request_builder.ex.mustache` adds `encode_path_param/1`. The
  generator interpolates path parameters raw (`#{envelope_id}`), and the
  script's post-processing wraps each one in `encode_path_param/1` so a value
  containing `/`, `?` or `#` stays a single path segment. This is a bridge until
  the upstream generator emits the encoding itself.
- `licenseInfo.mustache` emits a version-less header, so a generator upgrade
  does not touch every generated file.

The remaining templates (the Tesla `api.mustache` and
`request_builder.ex.mustache`, `README.md.mustache`, `mix.exs.mustache`,
`config.exs.mustache`, `connection.ex.mustache` and the other supporting files)
are byte-identical to the 7.26.0 extraction and exist only so generation does
not fail; the script copies none of their output into the library. To
re-extract upstream's set for comparison, with Java on `PATH` and from a
temporary directory so the CLI's `openapitools.json` stays out of the worktree:

```bash
PATH="/opt/homebrew/opt/openjdk/bin:$PATH" openapi-generator-cli author template -g elixir --library req -o DIR
```

The regeneration script requires OpenAPI Generator 7.26.0 or newer and fails
early on older releases, which would silently fall back to the Tesla templates.

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
2. Encodes path parameters as a bridge until the upstream generator emits encoding
3. Converts developer-site links to absolute URLs and removes trailing whitespace
4. Ensures all files pass `mix format`
5. Runs the test suite to verify compatibility

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
