defmodule DocuSign.OAuth.Fake do
  @moduledoc """
  Fake OAuth implementation mainly for test environment.
  """

  @behaviour DocuSign.OAuth

  @impl DocuSign.OAuth
  def client(_opts \\ []) do
    client_id = Application.fetch_env!(:docusign, :client_id)
    user_id = Application.get_env(:docusign, :user_id)
    hostname = Application.fetch_env!(:docusign, :hostname)
    token_expires_in = Application.get_env(:docusign, :token_expires_in, 2 * 60 * 60)

    OAuth2.Client.new(
      client_id: client_id,
      ref: %{
        hostname: hostname,
        token_expires_in: token_expires_in,
        user_id: user_id
      }
    )
  end

  @impl DocuSign.OAuth
  def get_token!(client, _params \\ [], _headers \\ [], _opts \\ []) do
    %{client | token: OAuth2.AccessToken.new(":token:")}
  end

  @impl DocuSign.OAuth
  def interval_refresh_token(_client) do
    1_000
  end

  @impl DocuSign.OAuth
  def refresh_token!(client, _force \\ false) do
    %{client | token: OAuth2.AccessToken.new(":refreshed-token:")}
  end

  @impl DocuSign.OAuth
  def token_expired?(_access_token_or_client), do: false

  @impl DocuSign.OAuth
  def get_client_info(_client) do
    %{
      "accounts" => [
        %{
          "account_id" => ":account-id:",
          "account_name" => ":account-name:",
          "base_uri" => "https://demo.docusign.net",
          "is_default" => true
        }
      ],
      "created" => "2018-09-07T23:49:34.163",
      "email" => ":email:",
      "family_name" => ":family-name:",
      "given_name" => ":given-name:",
      "name" => ":name:",
      "sub" => ":user-id:"
    }
  end
end
