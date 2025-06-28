# DocuSign API Client

Unofficial DocuSign Elixir Library used to interact with the eSignature REST API. Send, sign, and approve documents using this client.

## Quick Start with LiveBook

**The easiest way to get started** is through our interactive LiveBook examples:

### Embedded Signing (JWT Impersonation)
Complete working demonstration of DocuSign embedded signing with JWT authentication:

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https://github.com/neilberkman/docusign_elixir/blob/main/examples/embedded_signing.livemd)

### OAuth2 Authorization Code Flow
Interactive walkthrough of the OAuth2 Authorization Code Flow for user-facing applications:

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https://github.com/neilberkman/docusign_elixir/blob/main/examples/oauth_authorization_code_flow.livemd)

Just click the badges above to run the notebooks in LiveBook - no environment setup required!

## Installation

The package can be installed by adding `docusign` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docusign, "~> 2.2.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/docusign](https://hexdocs.pm/docusign).

## Usage

DocuSign Elixir supports two authentication methods:

1. **OAuth2 Authorization Code Flow** - For user-facing applications where users grant permission
2. **JWT Impersonation** - For server-to-server applications with pre-configured access

### OAuth2 Authorization Code Flow

**Recommended for user-facing applications** where users need to grant permission for your app to access their DocuSign account.

#### Benefits
- Users explicitly grant permission through DocuSign's consent screen
- No admin pre-approval required (unlike JWT impersonation)
- Tokens can be refreshed without user interaction
- Standard OAuth2 compliance

#### Quick Setup

```elixir
config :docusign,
  hostname: "account-d.docusign.com", # or "account.docusign.com" for production
  client_id: "your_integration_key",
  client_secret: "your_secret_key"
```

#### Usage

```elixir
# 1. Create OAuth2 client
client = DocuSign.OAuth.AuthorizationCodeStrategy.client(
  redirect_uri: "https://yourapp.com/auth/callback"
)

# 2. Generate authorization URL (redirect user here)
auth_url = OAuth2.Client.authorize_url!(client, scope: "signature")

# 3. Exchange authorization code for tokens (in your callback handler)
client = OAuth2.Client.get_token!(client, code: auth_code_from_callback)

# 4. Get user info and create connection
user_info = DocuSign.OAuth.AuthorizationCodeStrategy.get_user_info!(client)
account = Enum.find(user_info["accounts"], &(&1["is_default"] == "true"))

{:ok, conn} = DocuSign.Connection.from_oauth_client(
  client,
  account_id: account["account_id"],
  base_uri: account["base_uri"] <> "/restapi"
)

# 5. Use connection with DocuSign APIs
{:ok, users} = DocuSign.Api.Users.users_get_users(conn, account["account_id"])
```

**💡 For a complete interactive example, see the [OAuth2 LiveBook guide](https://livebook.dev/run?url=https://github.com/neilberkman/docusign_elixir/blob/main/examples/oauth_authorization_code_flow.livemd)!**

### JWT Impersonation

**For server-to-server applications** where you need to act on behalf of users with pre-configured access.

#### Requirements
- RSA Private key
- DocuSign Client ID (integration key)  
- DocuSign Account ID
- One or more DocuSign User IDs

Note that you can test your integration with the full-featured sandbox environment provided by [DocuSign](https://appdemo.docusign.com).

#### Application Configuration

```elixir
config :docusign,
  hostname: "account-d.docusign.com",
  client_id: "?????-?????-???????",
  private_key_file: "docusign_key.pem"
```

**Notes:**
- Set hostname to `account.docusign.com` for production
- Private key path can be relative or absolute
- Use `private_key_contents` instead of `private_key_file` for secrets stored in vault systems

#### Optional Configuration

```elixir
config :docusign,
  timeout: 30_000,        # 30 seconds
  token_expires_in: 7_200 # 2 hours
```

#### Environment Variables (Recommended)

For security, use environment variables instead of hardcoding credentials:

```bash
# .env file
export DOCUSIGN_CLIENT_ID=<client id here>
export DOCUSIGN_PRIVATE_KEY_FILE=<private key file path here>
```

```elixir
# config.exs
config :docusign,
  client_id: System.fetch_env!("DOCUSIGN_CLIENT_ID"),
  private_key_file: System.fetch_env!("DOCUSIGN_PRIVATE_KEY_FILE")
```

#### DocuSign Setup for JWT

1. Access DocuSign admin and go to **Settings** → **Apps & Keys**
2. Note the **API Account ID** (this is your Account ID)
3. Create a new app:
   - Provide a name
   - In **Authentication**, click **+ GENERATE RSA** 
   - Store the private key securely
   - Add redirect URI: `https://account-d.docusign.com/me` (sandbox) or `https://account.docusign.com/me` (production)
4. Note the **Integration Key** (this is your Client ID)

#### User Consent for Impersonation

For impersonating other users, they must first consent by visiting:

**Sandbox:**
```
https://account-d.docusign.com/oauth/auth?response_type=code&scope=signature%20impersonation&client_id=YOUR_CLIENT_ID&redirect_uri=https://account-d.docusign.com/me
```

**Production:**
```
https://account.docusign.com/oauth/auth?response_type=code&scope=signature%20impersonation&client_id=YOUR_CLIENT_ID&redirect_uri=https://account.docusign.com/me
```

#### Using JWT APIs

```elixir
# Establish connection
user_id = "USER_ID"
{:ok, conn} = DocuSign.Connection.get(user_id)

# Call APIs
account_id = "ACCOUNT_ID"  
{:ok, users} = DocuSign.Api.Users.users_get_users(conn, account_id)
```

## Timeout configuration

By default, HTTP requests will time out after 30_000 ms. You can configure the timeout:

```elixir
config :docusign, timeout: 60_000
```

## Tesla adapter configuration

By default, the API is called using `Tesla` with the Mint adapter. You can override the adapter
to any [Tesla adapter][tesla_adapters]:

```elixir
config :docusign, adapter: {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
```

## DocuSign Connect

To receive webhooks from DocuSign Connect, you can use `DocuSign.WebhookPlug` with
your custom webhook handler. See the documentation of `DocuSign.WebhookPlug` for more
details.

## Migration Guide

For information about migrating between versions, please see [MIGRATING.md](MIGRATING.md).

## Regenerating the Library

### Using Regeneration Scripts

The DocuSign Elixir library can be regenerated using the provided script in the `scripts/regen` directory. This script handles:

1. Preserving custom functionality (like ModelCleaner)
2. Updating generated code from the latest OpenAPI specification
3. Adjusting module names and references
4. Running tests to verify everything works

To regenerate the library:

1. Download the latest OpenAPI specification:

```bash
curl -o /tmp/docusign_regen/esignature.swagger.json https://raw.githubusercontent.com/docusign/eSign-OpenAPI-Specification/master/esignature.rest.swagger-v2.1.json
```

2. Generate the client code:

```bash
openapi-generator generate -i /tmp/docusign_regen/esignature.swagger.json -g elixir -o /tmp/docusign_regen/elixir_api_client --additional-properties=packageName=docusign_e_signature_restapi
```

3. Run the regeneration script:

```bash
cd scripts/regen
chmod +x regenerate_library.sh
./regenerate_library.sh
```

See the [regeneration README](scripts/regen/README.md) for more details.

[tesla_adapters]: https://hexdocs.pm/tesla/readme.html#adapters
