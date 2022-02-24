import Config

config :docusign, app_env: :test
config :docusign, hostname: "account-d.docusign.com"
config :docusign, private_key: "test/support/test_key"
config :docusign, user_id: ":user-id:"

config :docusign, oauth_implementation: DocuSign.OAuth.Fake
