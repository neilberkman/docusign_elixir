defmodule DocuSign.ConnectionDebugTest do
  use ExUnit.Case, async: false

  alias DocuSign.Connection
  alias DocuSign.Debug
  alias Tesla.Middleware.BaseUrl
  alias Tesla.Middleware.EncodeJson
  alias Tesla.Middleware.Headers
  alias Tesla.Middleware.Logger

  describe "Tesla client middleware integration" do
    setup do
      # Save original config
      original_debugging = Application.get_env(:docusign, :debugging)

      on_exit(fn ->
        # Restore original config
        if original_debugging do
          Application.put_env(:docusign, :debugging, original_debugging)
        else
          Application.delete_env(:docusign, :debugging)
        end
      end)
    end

    test "JWT connection includes debugging middleware when enabled" do
      Debug.enable_debugging()

      # Mock a JWT client structure
      mock_connection = %{
        app_account: %{base_uri: "https://demo.docusign.net/restapi"},
        client: %{token: %{access_token: "test-token", token_type: "Bearer"}}
      }

      client = Connection.Request.new(mock_connection)

      # Verify client was created (this tests middleware compilation)
      assert %Tesla.Client{} = client

      # The middleware should include debug logging and SDK headers
      middleware_modules = client.pre |> Enum.map(&elem(&1, 0))

      assert BaseUrl in middleware_modules
      assert Headers in middleware_modules
      assert EncodeJson in middleware_modules
      assert Logger in middleware_modules
    end

    test "OAuth2 connection includes debugging middleware when enabled" do
      Debug.enable_debugging()

      # Mock an OAuth2 client structure
      mock_connection = %{
        app_account: %{base_uri: "https://demo.docusign.net/restapi"},
        client: %OAuth2.Client{
          token: %OAuth2.AccessToken{
            access_token: "test-oauth-token",
            token_type: "Bearer"
          }
        }
      }

      client = Connection.Request.new(mock_connection)

      # Verify client was created (this tests middleware compilation)
      assert %Tesla.Client{} = client

      # The middleware should include debug logging and SDK headers
      middleware_modules = client.pre |> Enum.map(&elem(&1, 0))

      assert BaseUrl in middleware_modules
      assert Headers in middleware_modules
      assert EncodeJson in middleware_modules
      assert Logger in middleware_modules
    end

    test "connections exclude debugging middleware when disabled" do
      Debug.disable_debugging()

      # Mock a JWT client structure
      mock_connection = %{
        app_account: %{base_uri: "https://demo.docusign.net/restapi"},
        client: %{token: %{access_token: "test-token", token_type: "Bearer"}}
      }

      client = Connection.Request.new(mock_connection)

      # Verify client was created
      assert %Tesla.Client{} = client

      # The middleware should NOT include debug logging
      middleware_modules = client.pre |> Enum.map(&elem(&1, 0))

      assert BaseUrl in middleware_modules
      assert Headers in middleware_modules
      assert EncodeJson in middleware_modules
      refute Logger in middleware_modules
    end

    test "SDK headers are properly configured in middleware" do
      # Test that SDK headers middleware is properly configured
      sdk_middleware = Debug.sdk_headers()

      assert [{Headers, headers}] = sdk_middleware

      # Check for SDK identification headers
      sdk_header = List.keyfind(headers, "X-DocuSign-SDK", 0)
      assert {"X-DocuSign-SDK", value} = sdk_header
      assert String.starts_with?(value, "Elixir/")

      user_agent_header = List.keyfind(headers, "User-Agent", 0)
      assert {"User-Agent", value} = user_agent_header
      assert String.starts_with?(value, "DocuSign-Elixir/")
    end
  end

  describe "environment detection functions" do
    test "determine_hostname delegates to Environment module" do
      assert Connection.determine_hostname("https://demo.docusign.net/restapi") ==
               "account-d.docusign.com"

      assert Connection.determine_hostname("https://www.docusign.net/restapi") ==
               "account.docusign.com"
    end

    test "detect_environment delegates to Environment module" do
      assert Connection.detect_environment("https://demo.docusign.net/restapi") == :sandbox
      assert Connection.detect_environment("https://www.docusign.net/restapi") == :production
    end
  end
end
