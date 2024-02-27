# DocuSign API Client

Unofficial DocuSign Elixir Library used to interact with the eSignature REST API. Send, sign, and approve documents using this client.

## Installation

The package can be installed by adding `docusign` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docusign, "~> 1.2.0"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/docusign](https://hexdocs.pm/docusign).

## Usage

In order to use this library with DocuSign, you need the following configured in your app:

- RSA Private key
- DocuSign Client ID (integration key)
- DocuSign Account ID
- One or more DocuSign User IDs

Note that you can test your integration with the full-featured sandbox environment provided
by [DocuSign](https://appdemo.docusign.com).

### Application configuration

You will need to set the following configuration variables in your config file:

```
config :docusign,
  hostname: "account-d.docusign.com",
  client_id: "?????-?????-???????",
  private_key_file: "docusign_key.pem"
```

Notes:

- the hostname should be set to `account.docusign.com` for the production environment
- the path for the private key file can be relative or absolute
- the private key can also be configured with `private_key_contents`, which is the contents
of the private key file. This is useful when you do not store the private key on disk,
but in a secrets store such as Hashicorp Vault or AWS Secrets Manager.

Optional configuration with default values:

```
config :docusign,
  timeout: 30_000, # 30 seconds
  token_expires_in: 7_200 # 2 hours
```

The `Account ID` is required when you call API functions. It is up to you to decide on how
you want to configure your application. Same thing with the `User ID`.

For security, we recommend that you use environment variables rather than hard coding your credentials. If you don't already have an environment variable manager, you can create a .env file in your project with the following content:

```
export DOCUSIGN_CLIENT_ID=<client id here>
export DOCUSIGN_PRIVATE_KEY=<private key file path here>
```

And the corresponding config file:

```
config :docusign,
  client_id: System.fetch_env!("DOCUSIGN_CLIENT_ID"),
  private_key_file: System.fetch_env!("DOCUSIGN_PRIVATE_KEY")
```

Then, just be sure to run `source .env` in your shell before compiling your project.

### Configuring DocuSign

Access DocuSign using an administrator account and go in `Settings`.

1. Under `Apps & Keys`, note the `API Account ID`. This is the `Account ID` mentioned above.
2. Create a new app:
   1. Provide a name.
   2. In section `Authentication`, click on `+ GENERATE RSA`. Store securely the information provided. The private key will have to be provided in the config files of your app (or in a file).
   3. Add a redirect URI for: `https://account-d.docusign.com/me` (or `https://account.docusign.com/me` if on the DocuSign production site). Important for users to consent the impersonation of your app.
3. Under `Apps & Keys`, note the `Integration key` of the app you just added. This is the `Client ID` mentionned above.

If you want, you can use your administrator user with the API. The user ID is displayed in the
`My account information` frame on the `Apps & Keys` page. But it would most likely be safer to create
a user for it (see below).

### Impersonate another user through the API

If you want to use the API through other DocuSign users (impersonation), you first need to create the user in
DocuSign, then you have to ask the user to `consent` the impersonation that your app will do.
To do so, after you created the user, send them the following link (replace `DOCUSIGN_CLIENT_ID` with the ID configured above):

Sandbox:
`https://account-d.docusign.com/oauth/auth?response_type=code&scope=signature%20impersonation&client_id=DOCUSIGN_CLIENT_ID&redirect_uri=https://account-d.docusign.com/me`

Production:
`https://account.docusign.com/oauth/auth?response_type=code&scope=signature%20impersonation&client_id=DOCUSIGN_CLIENT_ID&redirect_uri=https://account.docusign.com/me`

The user will then have to sign in and approve your application to use their credentials.

The `user ID` to use with `Connection` and `ClientRegistry` is the `API Username` on the user's profile
page in DocuSign.

### Using the API

Before calling API functions (`DocuSign.API.xxx`), you must first establish a connection to the
DocuSign API:

```
user_id = "USER_ID"
{:ok, conn} = DocuSign.Connection.get(user_id)
```

You can then use any function from the `DocuSign.API` namespace. For instance:

```
account_id = "ACCOUNT_ID"
{:ok, users} = DocuSign.Api.Users.users_get_users(conn, account_id)
```

## Timeout configuration

By default, the HTTP requests will timeout after 30_000 ms. You can configure the timeout:

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

## Migrating from 0.3.x to 0.4.0

Version 0.4.0 brings the ability to call DocuSign API with different user IDs. This is useful if your
users have different security restrictions in DocuSign. The `ClientRegistry` takes care or tracking
the API client for those users and refresh the access tokens.

`Connection.new/0` has been deprecated. You should replace calls to `Connection.new/0` with `Connection.get/1` and provide a user ID.

`APIClient` functions have been deprecated. Please use corresponding functions in `ClientRegistry`.

## Regenerating stubs

1. Install the latest [OpenAPI Generator](https://openapi-generator.tech/docs/installation).
2. NOTE: When updating the version of OpenAPI Generator, updating the "OpenAPI Generator 6.4.0" comment header in a separate commit beforehand will make the other changes easier to review.
3. Download the latest [DocuSign OpenAPI Specification](https://raw.githubusercontent.com/docusign/eSign-OpenAPI-Specification/master/esignature.rest.swagger-v2.1.json) file (or "swagger" file).
4. Change the title in the swagger file to "DocuSign" (the path to the title in JSON is `info.title`).
5. Rename the `"number"` definition to `"docuSignNumber"` and update the $ref's to use `"#/definitions/docuSignNumber"`.
6. Rename the `"date"` definition to `"docuSignDate"` and update the $ref's to use `"#/definitions/docuSignDate"`.
7. Execute the following commands:

```bash
openapi-generator generate -i "esignature.rest.swagger-v2.1.json" -g "elixir" -o "/tmp/elixir_api_client"
rm -rf lib/docusign/api/*
rm -rf lib/docusign/model/*
cp -rf /tmp/elixir_api_client/lib/docu_sign/api/* lib/docusign/api
cp -rf /tmp/elixir_api_client/lib/docu_sign/model/* lib/docusign/model
mix format
```

NOTE: To minimize differences, also trim trailing whitespace by replacing ` +$` with nothing across all files.

## JWT Authorization Example

See the [Elixir sample](https://github.com/neilberkman/docusign_elixir_sample_app) for an example Elixir SDK implementation that uses the JWT bearer grant to authenticate.

[tesla_adapters]: https://hexdocs.pm/tesla/readme.html#adapters
