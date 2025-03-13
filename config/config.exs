# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
import Config

# Using the recommended approach instead of deprecated private_key
config :docusign, private_key_file: System.get_env("DOCUSIGN_PRIVATE_KEY") || "docusign_key.pem"
config :docusign, token_expires_in: 3600

config :docusign, client_id: System.get_env("DOCUSIGN_CLIENT_ID")

config :docusign, user_id: System.get_env("DOCUSIGN_USER_ID")

import_config "#{Mix.env()}.exs"

config :tesla, adapter: Tesla.Adapter.Mint

if File.exists?("config/#{Mix.env()}.secret.exs") do
  import_config "#{Mix.env()}.secret.exs"
end
