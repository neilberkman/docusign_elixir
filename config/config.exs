# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
import Config

# DocuSign OAuth Configuration
# Using the recommended approach with proper environment variable naming
config :docusign, client_id: System.get_env("DOCUSIGN_CLIENT_ID")

config :docusign,
  private_key_file: System.get_env("DOCUSIGN_PRIVATE_KEY_FILE") || "docusign_key.pem"

config :docusign, token_expires_in: 3600
config :docusign, user_id: System.get_env("DOCUSIGN_USER_ID")

# HTTP Client Configuration (Req + Finch)
# The library uses Req with Finch as the underlying HTTP client.
# Req automatically manages its own Finch instance named Req.Finch.
#
# To configure advanced HTTP options (timeouts, pool sizes, etc.), you can:
# 1. Pass options directly when creating a connection
# 2. Configure the default Req.Finch instance globally:
#
#     config :req, :finch_options, [
#       pools: %{
#         :default => [size: 50, count: 1]
#       }
#     ]
#
# See https://hexdocs.pm/finch/Finch.html#start_link/1 for all available options

import_config "#{Mix.env()}.exs"

if File.exists?("config/#{Mix.env()}.secret.exs") do
  import_config "#{Mix.env()}.secret.exs"
end
