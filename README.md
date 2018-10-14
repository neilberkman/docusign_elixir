# DocuSign API Client

[![CircleCI](https://circleci.com/gh/tandemequity/docusign_elixir.svg?style=svg)](https://circleci.com/gh/tandemequity/docusign_elixir) [![Ebert](https://ebertapp.io/github/tandemequity/docusign_elixir.svg)](https://ebertapp.io/github/tandemequity/docusign_elixir)

Unofficial DocuSign Elixir Library used to interact with the eSign REST API. Send, sign, and approve documents using this client.

## Installation

The package can be installed by adding `docusign` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docusign, "~> 0.1.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/docusign](https://hexdocs.pm/docusign).

## JWT Authorization Example

See the [Elixir sample](https://github.com/tandemequity/docusign_elixir_sample_app) for an example Elixir SDK implementation that uses the JWT bearer grant to authenticate.