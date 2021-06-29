use Mix.Config

config :docusign, app_env: :dev

config :docusign, hostname: "account-d.docusign.com"

config :oauth2,
  debug: true,
  request_options: [
    recv_timeout: 10_000,
    timeout: 8_000
  ],
  warn_missing_serializer: false
