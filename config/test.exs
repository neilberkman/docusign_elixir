import Config

alias DocuSign.OAuth.Fake

config :docusign, app_env: :test
config :docusign, hostname: "account-d.docusign.com"
config :docusign, oauth_implementation: Fake
config :docusign, private_key_file: "test/support/test_key"
config :docusign, user_id: ":user-id:"
