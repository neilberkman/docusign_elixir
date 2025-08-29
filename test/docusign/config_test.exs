defmodule DocuSign.ConfigTest do
  use ExUnit.Case

  describe "high-level configuration" do
    test "timeout configuration is used when building connections" do
      # Set custom timeout
      original_timeout = Application.get_env(:docusign, :timeout)
      Application.put_env(:docusign, :timeout, 45_000)

      try do
        # Create connection from OAuth client
        oauth_client = %OAuth2.Client{
          token: %OAuth2.AccessToken{
            access_token: "test_token",
            token_type: "Bearer"
          }
        }

        {:ok, conn} =
          DocuSign.Connection.from_oauth_client(
            oauth_client,
            account_id: "test_account",
            base_uri: "https://demo.docusign.net/restapi"
          )

        # Verify timeout is set in Req options
        assert conn.req.options.receive_timeout == 45_000
      after
        # Restore original config
        if original_timeout do
          Application.put_env(:docusign, :timeout, original_timeout)
        else
          Application.delete_env(:docusign, :timeout)
        end
      end
    end

    test "pool configuration is used by Finch" do
      # Set custom pool config
      original_size = Application.get_env(:docusign, :pool_size)
      original_count = Application.get_env(:docusign, :pool_count)

      Application.put_env(:docusign, :pool_size, 20)
      Application.put_env(:docusign, :pool_count, 2)

      try do
        # Get finch pools configuration
        pools = DocuSign.Application.finch_pools()

        assert pools[:default][:size] == 20
        assert pools[:default][:count] == 2
      after
        # Restore original config
        if original_size do
          Application.put_env(:docusign, :pool_size, original_size)
        else
          Application.delete_env(:docusign, :pool_size)
        end

        if original_count do
          Application.put_env(:docusign, :pool_count, original_count)
        else
          Application.delete_env(:docusign, :pool_count)
        end
      end
    end

    test "debug configuration enables request/response logging" do
      # Set debug mode
      original_debug = Application.get_env(:docusign, :debug)
      Application.put_env(:docusign, :debug, true)

      try do
        # Create connection from OAuth client
        oauth_client = %OAuth2.Client{
          token: %OAuth2.AccessToken{
            access_token: "test_token",
            token_type: "Bearer"
          }
        }

        {:ok, conn} =
          DocuSign.Connection.from_oauth_client(
            oauth_client,
            account_id: "test_account",
            base_uri: "https://demo.docusign.net/restapi"
          )

        # Verify debug steps are added
        request_step_names = Keyword.keys(conn.req.request_steps)
        response_step_names = Keyword.keys(conn.req.response_steps)

        assert :debug_request in request_step_names
        assert :debug_response in response_step_names
      after
        # Restore original config
        if original_debug do
          Application.put_env(:docusign, :debug, original_debug)
        else
          Application.delete_env(:docusign, :debug)
        end
      end
    end
  end
end
