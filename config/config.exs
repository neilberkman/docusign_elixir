# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :docusign, private_key: System.get_env("DOCUSIGN_PRIVATE_KEY") || "docusign_key.pem"
config :docusign, token_expires_in: 3600

config :docusign,
  client_id: System.get_env("DOCUSIGN_CLIENT_ID")

config :docusign,
  user_id: System.get_env("DOCUSIGN_USER_ID")

import_config "#{Mix.env()}.exs"

config :tesla, adapter: Tesla.Adapter.Mint

if File.exists?("config/#{Mix.env()}.secret.exs") do
  import_config "#{Mix.env()}.secret.exs"
end
