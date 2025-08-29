defmodule DocuSign.ConnectionEnvironmentTest do
  # Modifies global config, can't run async
  use ExUnit.Case, async: false

  alias DocuSign.Connection

  describe "determine_hostname/1" do
    test "delegates to Environment module for sandbox detection" do
      assert Connection.determine_hostname("https://demo.docusign.net/restapi") ==
               "account-d.docusign.com"

      assert Connection.determine_hostname("https://apps-d.docusign.com") ==
               "account-d.docusign.com"
    end

    test "delegates to Environment module for production detection" do
      assert Connection.determine_hostname("https://na3.docusign.net/restapi") ==
               "account.docusign.com"

      assert Connection.determine_hostname("https://eu.docusign.net/restapi") ==
               "account.docusign.com"
    end
  end

  describe "detect_environment/1" do
    test "delegates to Environment module for environment detection" do
      assert Connection.detect_environment("https://demo.docusign.net/restapi") == :sandbox
      assert Connection.detect_environment("https://na3.docusign.net/restapi") == :production
    end
  end

  describe "from_oauth_client_with_detection/2" do
    setup do
      # Create a mock OAuth2 client
      oauth_client = %OAuth2.Client{
        token: %OAuth2.AccessToken{
          access_token: "test_token",
          token_type: "Bearer"
        }
      }

      {:ok, oauth_client: oauth_client}
    end

    test "creates connection without auto-detection by default", %{oauth_client: oauth_client} do
      # Store original hostname
      original_hostname = Application.get_env(:docusign, :hostname)

      try do
        # Set a production hostname initially
        Application.put_env(:docusign, :hostname, "account.docusign.com")

        {:ok, _conn} =
          Connection.from_oauth_client_with_detection(
            oauth_client,
            account_id: "test_account",
            base_uri: "https://demo.docusign.net/restapi"
          )

        # Hostname should remain unchanged since auto_detect_hostname was not set
        assert Application.get_env(:docusign, :hostname) == "account.docusign.com"
      after
        # Restore original hostname
        if original_hostname do
          Application.put_env(:docusign, :hostname, original_hostname)
        else
          Application.delete_env(:docusign, :hostname)
        end
      end
    end

    test "automatically detects and sets sandbox hostname when enabled", %{
      oauth_client: oauth_client
    } do
      # Store original hostname
      original_hostname = Application.get_env(:docusign, :hostname)

      try do
        # Set a production hostname initially
        Application.put_env(:docusign, :hostname, "account.docusign.com")

        {:ok, _conn} =
          Connection.from_oauth_client_with_detection(
            oauth_client,
            account_id: "test_account",
            base_uri: "https://demo.docusign.net/restapi",
            auto_detect_hostname: true
          )

        # Hostname should be automatically updated to sandbox
        assert Application.get_env(:docusign, :hostname) == "account-d.docusign.com"
      after
        # Restore original hostname
        if original_hostname do
          Application.put_env(:docusign, :hostname, original_hostname)
        else
          Application.delete_env(:docusign, :hostname)
        end
      end
    end

    test "automatically detects and sets production hostname when enabled", %{
      oauth_client: oauth_client
    } do
      # Store original hostname
      original_hostname = Application.get_env(:docusign, :hostname)

      try do
        # Set a sandbox hostname initially
        Application.put_env(:docusign, :hostname, "account-d.docusign.com")

        {:ok, _conn} =
          Connection.from_oauth_client_with_detection(
            oauth_client,
            account_id: "test_account",
            base_uri: "https://na3.docusign.net/restapi",
            auto_detect_hostname: true
          )

        # Hostname should be automatically updated to production
        assert Application.get_env(:docusign, :hostname) == "account.docusign.com"
      after
        # Restore original hostname
        if original_hostname do
          Application.put_env(:docusign, :hostname, original_hostname)
        else
          Application.delete_env(:docusign, :hostname)
        end
      end
    end

    test "handles missing base_uri gracefully with auto-detection enabled", %{
      oauth_client: oauth_client
    } do
      # Store original hostname
      original_hostname = Application.get_env(:docusign, :hostname)

      try do
        # Set a hostname initially
        Application.put_env(:docusign, :hostname, "account.docusign.com")

        # This should fail due to missing account_id, but not crash during hostname detection
        {:error, {:missing_required_option, :account_id}} =
          Connection.from_oauth_client_with_detection(
            oauth_client,
            base_uri: "https://demo.docusign.net/restapi",
            auto_detect_hostname: true
          )

        # Hostname should still be updated since base_uri was provided
        assert Application.get_env(:docusign, :hostname) == "account-d.docusign.com"
      after
        # Restore original hostname
        if original_hostname do
          Application.put_env(:docusign, :hostname, original_hostname)
        else
          Application.delete_env(:docusign, :hostname)
        end
      end
    end

    test "skips auto-detection when base_uri is missing", %{oauth_client: oauth_client} do
      # Store original hostname
      original_hostname = Application.get_env(:docusign, :hostname)

      try do
        # Set a hostname initially
        Application.put_env(:docusign, :hostname, "account.docusign.com")

        # This should fail due to missing required options
        {:error, {:missing_required_option, :account_id}} =
          Connection.from_oauth_client_with_detection(
            oauth_client,
            auto_detect_hostname: true
          )

        # Hostname should remain unchanged since no base_uri was provided
        assert Application.get_env(:docusign, :hostname) == "account.docusign.com"
      after
        # Restore original hostname
        if original_hostname do
          Application.put_env(:docusign, :hostname, original_hostname)
        else
          Application.delete_env(:docusign, :hostname)
        end
      end
    end

    test "creates valid connection structure", %{oauth_client: oauth_client} do
      {:ok, conn} =
        Connection.from_oauth_client_with_detection(
          oauth_client,
          account_id: "test_account",
          base_uri: "https://demo.docusign.net/restapi"
        )

      assert %Connection{} = conn
      assert conn.client == oauth_client
      assert conn.app_account.account_id == "test_account"
      assert conn.app_account.base_uri == "https://demo.docusign.net/restapi"
    end
  end
end
