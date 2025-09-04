[![Hex.pm](https://img.shields.io/hexpm/v/docusign)](https://hex.pm/packages/docusign)
[![Hexdocs.pm](https://img.shields.io/badge/docs-hexdocs.pm-purple)](https://hexdocs.pm/docusign)
[![Github.com](https://github.com/neilberkman/docusign_elixir/actions/workflows/elixir.yml/badge.svg)](https://github.com/neilberkman/docusign_elixir/actions)

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

### SSL Configuration Example

Learn how to configure SSL/TLS options for secure connections:

1. Configure custom CA certificates
2. Set up client certificate authentication
3. Understand security best practices
4. Test your SSL configuration

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https://github.com/neilberkman/docusign_elixir/blob/main/examples/ssl_configuration.livemd)

Just click the badges above to run the notebooks in LiveBook - no environment setup required!

## Installation

The package can be installed by adding `docusign` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docusign, "~> 3.0.0"}
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

> **Using Überauth?** Check out [ueberauth_docusign](https://github.com/neilberkman/ueberauth_docusign) for seamless DocuSign OAuth integration with Phoenix applications!

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

#### Environment Auto-Detection

Automatically determine the correct OAuth hostname based on your API base URI:

```elixir
# Automatically detect sandbox vs production from base URI
base_uri = "https://demo.docusign.net/restapi"
hostname = DocuSign.Connection.determine_hostname(base_uri)  # "account-d.docusign.com"

# Configure OAuth with auto-detected hostname
Application.put_env(:docusign, :hostname, hostname)

# Or use the enhanced connection function with auto-detection
{:ok, conn} = DocuSign.Connection.from_oauth_client_with_detection(
  oauth_client,
  account_id: account["account_id"],
  base_uri: account["base_uri"] <> "/restapi",
  auto_detect_hostname: true  # Automatically sets hostname config
)
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

## Request/Response Debugging

The DocuSign Elixir client provides comprehensive debugging capabilities for HTTP requests and responses, similar to the Ruby client's debugging features.

### Enable Debugging

Enable debugging in your configuration to log HTTP request/response details:

```elixir
config :docusign, debugging: true
```

Or enable it at runtime:

```elixir
DocuSign.Debug.enable_debugging()
```

### Debug Output

When debugging is enabled, you'll see detailed logs including:

- HTTP request method, URL, and timing
- Request and response headers (with sensitive data filtered)
- Request and response bodies
- SDK identification headers

Example debug output:

```
[debug] GET https://demo.docusign.net/restapi/v2.1/accounts -> 200 (145.2 ms)
[debug] Request headers: [{"authorization", "[FILTERED]"}, {"X-DocuSign-SDK", "Elixir/3.0.0"}]
[debug] Response body: {"accounts": [...]}
```

### Header Filtering

Sensitive headers like authorization tokens are automatically filtered in debug logs. You can customize which headers to filter:

```elixir
config :docusign, :debug_filter_headers, ["authorization", "x-api-key", "x-custom-secret"]
```

### SDK Identification

The client automatically includes SDK identification headers with all requests:

- `X-DocuSign-SDK: Elixir/2.2.2` - Identifies the SDK and version
- `User-Agent: DocuSign-Elixir/2.2.2` - Standard user agent header

These headers help DocuSign track API usage and provide better support.

### Configuration Options

```elixir
config :docusign,
  debugging: true,                    # Enable/disable debug logging
  debug_filter_headers: [             # Headers to filter in logs
    "authorization",
    "x-api-key"
  ]
```

## Timeout configuration

By default, HTTP requests will time out after 30_000 ms. You can configure the timeout:

```elixir
config :docusign, timeout: 60_000
```

## Structured Error Handling

The DocuSign Elixir client provides opt-in structured error handling, returning detailed error structs instead of generic tuples for API failures. This allows for more granular and robust error management in your application.

### Enable Structured Errors

To enable structured errors, set the `:structured_errors` option in your application configuration:

```elixir
config :docusign, :structured_errors, true
```

When enabled, API calls that result in an error (e.g., HTTP status codes 4xx or 5xx) will return an `{:error, error_struct}` tuple, where `error_struct` is one of the following:

- `DocuSign.ApiError`: A general API error.
- `DocuSign.AuthenticationError`: Specifically for 401 Unauthorized errors.
- `DocuSign.RateLimitError`: Specifically for 429 Too Many Requests errors.
- `DocuSign.ValidationError`: Specifically for 400 Bad Request errors.

Each error struct contains `message`, `status`, and `body` fields, providing comprehensive details about the error.

### Example Usage

```elixir
case DocuSign.Api.Envelopes.envelopes_get_envelope(conn, account_id, envelope_id) do
  {:ok, envelope} ->
    IO.puts("Envelope retrieved: #{envelope.status}")
  {:error, %DocuSign.AuthenticationError{message: msg, status: status}} ->
    IO.puts("Authentication failed (Status: #{status}): #{msg}")
  {:error, %DocuSign.ValidationError{message: msg, body: body}} ->
    IO.puts("Validation error: #{msg}. Details: #{inspect(body)}")
  {:error, %DocuSign.ApiError{message: msg, status: status}} ->
    IO.puts("API Error (Status: #{status}): #{msg}")
  {:error, reason} ->
    IO.puts("An unexpected error occurred: #{inspect(reason)}")
end
```

If `:structured_errors` is `false` (the default), errors will continue to be returned as `{:error, {:http_error, status, body}}` tuples for backward compatibility.

## SSL/TLS Configuration

The DocuSign client supports comprehensive SSL/TLS configuration for secure connections. This is particularly useful for:

- Using custom CA certificates
- Client certificate authentication (mutual TLS)
- Controlling SSL verification behavior
- Configuring cipher suites and TLS versions

### Basic SSL Configuration

Configure SSL options at the application level:

```elixir
config :docusign, :ssl_options,
  verify: :verify_peer,                    # Always verify server certificates (default)
  cacertfile: "/path/to/ca-bundle.crt",   # Custom CA certificate bundle
  depth: 3                                 # Certificate chain verification depth
```

### Client Certificate Authentication

For mutual TLS authentication:

```elixir
config :docusign, :ssl_options,
  certfile: "/path/to/client-cert.pem",   # Client certificate
  keyfile: "/path/to/client-key.pem",     # Client private key
  password: "keypassword"                  # Password for encrypted key (if needed)
```

### Advanced SSL Options

```elixir
config :docusign, :ssl_options,
  # TLS versions
  versions: [:"tlsv1.2", :"tlsv1.3"],

  # Cipher suites (example)
  ciphers: [
    "ECDHE-RSA-AES256-GCM-SHA384",
    "ECDHE-RSA-AES128-GCM-SHA256"
  ],

  # Custom hostname verification
  customize_hostname_check: [
    match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
  ],

  # Custom verification function
  verify_fun: {&MyApp.SSLVerification.verify/3, nil}
```

### Per-Request SSL Options

You can override SSL options for specific requests:

```elixir
{:ok, conn} = DocuSign.Connection.get(user_id)

# Use custom CA certificate for this request only
DocuSign.Connection.request(conn,
  method: :get,
  url: "/accounts",
  ssl_options: [
    cacertfile: "/special/ca.pem",
    verify: :verify_peer
  ]
)
```

### Connection Pooling

Optimize HTTP connections for high-throughput applications:

```elixir
# Enable connection pooling with custom configuration
config :docusign, :pool_options, [
  size: 50,               # Number of connections per pool (default: 10)
  count: 2,               # Number of pools for concurrency (default: 1)
  max_idle_time: 600_000, # Keep connections alive for 10 minutes (default: 5 minutes)
  timeout: 30_000         # Connection timeout in ms (default: 30 seconds)
]
```

Benefits of connection pooling:

- **Connection reuse** - Reduces overhead of establishing new HTTPS connections
- **Better throughput** - Multiple pools allow concurrent request handling
- **Resource management** - Automatic cleanup of idle connections
- **Performance monitoring** - Track pool health with `DocuSign.ConnectionPool.health()`

Example usage:

```elixir
# Check if pooling is enabled
DocuSign.ConnectionPool.enabled?()
#=> true

# Get current pool configuration
DocuSign.ConnectionPool.config()
#=> %{size: 50, count: 2, max_idle_time: 600_000, timeout: 30_000, enabled: true}

# Monitor pool health
{:ok, health} = DocuSign.ConnectionPool.health()
#=> {:ok, %{status: :healthy, message: "Connection pooling is active", config: %{...}}}
```

### Security Best Practices

1. **Always use `:verify_peer` in production** - Never disable certificate verification in production environments
2. **Keep CA certificates updated** - Ensure your CA bundle includes all necessary root certificates
3. **Use strong cipher suites** - Configure only secure cipher suites
4. **Enable hostname verification** - Always verify that the certificate matches the hostname

### Automatic CA Certificate Detection

If you don't specify CA certificates, the library will attempt to use them in this order:

1. User-specified `:cacertfile` or `:cacerts`
2. CAStore library (if available as a dependency)
3. System CA certificates from common locations
4. Erlang's built-in CA certificates as a fallback

## HTTP Client Configuration

The library uses [Req](https://hexdocs.pm/req) with [Finch](https://hexdocs.pm/finch) as the underlying HTTP client.
Req automatically manages its own Finch instance named `Req.Finch`.

### Advanced Configuration

To configure advanced HTTP options (connection pools, timeouts, etc.), you can configure the global Req.Finch instance:

```elixir
config :req, :finch_options, [
  pools: %{
    :default => [size: 50, count: 1],
    "https://demo.docusign.net" => [size: 10, count: 2]
  }
]
```

See the [Finch documentation](https://hexdocs.pm/finch/Finch.html#start_link/1) for all available options.

## Retry Configuration

The client includes automatic retry logic for transient failures. By default, it retries up to 3 times with exponential backoff.

### Configuration

```elixir
config :docusign, :retry_options,
  max_retries: 3,         # Maximum retry attempts (default: 3)
  backoff_factor: 2,      # Exponential backoff multiplier (default: 2)
  max_delay: 30_000       # Maximum delay between retries in ms (default: 30_000)

# Disable retries entirely
config :docusign, :retry_options, enabled: false
```

The client automatically handles rate limits (429 responses) by honoring the `Retry-After` header when present.

## Telemetry and Monitoring

The DocuSign client emits telemetry events for observability and monitoring. These events allow you to track API performance, error rates, and usage patterns.

### Available Events

The following telemetry events are emitted:

- `[:docusign, :api, :start]` - Fired when an API call begins
- `[:docusign, :api, :stop]` - Fired when an API call completes successfully
- `[:docusign, :api, :exception]` - Fired when an API call fails
- `[:docusign, :rate_limit, :hit]` - Fired when rate limited by DocuSign

Additionally, since the client uses Finch for HTTP, you also get:

- `[:finch, :request, :start]` - HTTP request started
- `[:finch, :request, :stop]` - HTTP request completed

### Basic Usage

Attach handlers to telemetry events:

```elixir
:telemetry.attach(
  "log-docusign-requests",
  [:docusign, :api, :stop],
  fn _event, measurements, metadata, _config ->
    IO.puts("API call to #{metadata.operation} took #{measurements.duration / 1_000_000}ms")
  end,
  nil
)
```

### Integration with Telemetry.Metrics

For production monitoring with tools like LiveDashboard:

```elixir
defmodule MyApp.Telemetry do
  import Telemetry.Metrics

  def metrics do
    [
      # API performance
      summary("docusign.api.duration",
        unit: {:native, :millisecond},
        tags: [:operation, :status]
      ),

      # Request counts
      counter("docusign.api.count", tags: [:operation]),

      # Error rates
      counter("docusign.api.exception.count", tags: [:operation])
    ]
  end
end
```

See `DocuSign.Telemetry` module documentation for complete details.

## DocuSign Connect

To receive webhooks from DocuSign Connect, you can use `DocuSign.WebhookPlug` with
your custom webhook handler. See the documentation of `DocuSign.WebhookPlug` for more
details.

## Migration Guide

For information about migrating between versions, please see [MIGRATING.md](MIGRATING.md).

## Regenerating the Library

The DocuSign Elixir library can be regenerated from the latest OpenAPI specification using the provided scripts.

```bash
cd scripts/regen
./regenerate_library.sh
```

See the [regeneration README](scripts/regen/README.md) for details.
