# DocuSign API Client

Unofficial DocuSign Elixir Library used to interact with the eSign REST API. Send, sign, and approve documents using this client.

## Installation

The package can be installed by adding `docusign` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docusign, "~> 0.3.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/docusign](https://hexdocs.pm/docusign).

## Regenerating stubs 

Grab the latest [swagger codegen jar](https://github.com/swagger-api/swagger-codegen#prerequisites) and:

```bash
java -jar swagger-codegen-cli.jar generate \
  -i https://raw.githubusercontent.com/docusign/eSign-OpenAPI-Specification/master/esignature.rest.swagger-v2.1.json \
  -l elixir -o /tmp/elixir_api_client
rm -rf lib/docusign/*
cp -r /tmp/elixir_api_client/lib/docu_sign_restapi/* lib/docusign
mix format
```

## JWT Authorization Example

See the [Elixir sample](https://github.com/neilberkman/docusign_elixir_sample_app) for an example Elixir SDK implementation that uses the JWT bearer grant to authenticate.
