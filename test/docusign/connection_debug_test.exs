defmodule DocuSign.ConnectionDebugTest do
  use ExUnit.Case, async: false

  alias DocuSign.Connection

  describe "Req client debug integration" do
    setup do
      # Save original config
      original_debug = Application.get_env(:docusign, :debug)

      on_exit(fn ->
        # Restore original config
        if original_debug do
          Application.put_env(:docusign, :debug, original_debug)
        else
          Application.delete_env(:docusign, :debug)
        end
      end)
    end

    test "connection includes debug steps when enabled" do
      Application.put_env(:docusign, :debug, true)

      # Create a connection using the from_oauth_client function
      oauth_client = %OAuth2.Client{
        token: %OAuth2.AccessToken{
          access_token: "test-token",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "https://demo.docusign.net/restapi"
        )

      # Verify the Req client was created with debug steps
      assert %Connection{req: req} = conn
      assert %Req.Request{} = req

      # Check that debug steps are registered
      assert :debug_request in Keyword.keys(req.request_steps)
      assert :debug_response in Keyword.keys(req.response_steps)
    end

    test "connection excludes debug steps when disabled" do
      Application.put_env(:docusign, :debug, false)

      # Create a connection using the from_oauth_client function
      oauth_client = %OAuth2.Client{
        token: %OAuth2.AccessToken{
          access_token: "test-token",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "https://demo.docusign.net/restapi"
        )

      # Verify the Req client was created without debug steps
      assert %Connection{req: req} = conn
      assert %Req.Request{} = req

      # Check that debug steps are NOT registered
      refute :debug_request in Keyword.keys(req.request_steps)
      refute :debug_response in Keyword.keys(req.response_steps)
    end

    test "SDK headers are properly configured" do
      # Create a connection
      oauth_client = %OAuth2.Client{
        token: %OAuth2.AccessToken{
          access_token: "test-token",
          token_type: "Bearer"
        }
      }

      {:ok, conn} =
        Connection.from_oauth_client(
          oauth_client,
          account_id: "test-account",
          base_uri: "https://demo.docusign.net/restapi"
        )

      # Check that SDK headers are included
      headers = conn.req.headers

      # Find SDK header (value might be a list)
      {_, sdk_value} = Enum.find(headers, fn {k, _} -> String.downcase(k) == "x-docusign-sdk" end)
      sdk_string = if is_list(sdk_value), do: List.first(sdk_value), else: sdk_value
      assert sdk_string =~ "Elixir/"

      # Find User-Agent header (value might be a list)
      {_, ua_value} = Enum.find(headers, fn {k, _} -> String.downcase(k) == "user-agent" end)
      ua_string = if is_list(ua_value), do: List.first(ua_value), else: ua_value
      assert ua_string =~ "docusign-elixir/"
    end
  end
end
