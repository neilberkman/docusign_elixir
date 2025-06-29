defmodule DocuSign.Util.EnvironmentTest do
  use ExUnit.Case, async: true

  alias DocuSign.Util.Environment

  doctest Environment

  describe "determine_hostname/1" do
    test "detects sandbox environment from demo URLs" do
      assert Environment.determine_hostname("https://demo.docusign.net/restapi") == "account-d.docusign.com"
      assert Environment.determine_hostname("http://demo.docusign.net") == "account-d.docusign.com"
      assert Environment.determine_hostname("https://demo.docusign.com/restapi") == "account-d.docusign.com"
    end

    test "detects sandbox environment from apps-d URLs" do
      assert Environment.determine_hostname("https://apps-d.docusign.com") == "account-d.docusign.com"
      assert Environment.determine_hostname("http://apps-d.docusign.com/restapi") == "account-d.docusign.com"
      assert Environment.determine_hostname("https://apps-d.docusign.net") == "account-d.docusign.com"
    end

    test "detects production environment from production URLs" do
      assert Environment.determine_hostname("https://na3.docusign.net/restapi") == "account.docusign.com"
      assert Environment.determine_hostname("https://eu.docusign.net/restapi") == "account.docusign.com"
      assert Environment.determine_hostname("https://www.docusign.net/restapi") == "account.docusign.com"
      assert Environment.determine_hostname("https://docusign.net") == "account.docusign.com"
    end

    test "handles URLs with various paths" do
      assert Environment.determine_hostname("https://demo.docusign.net/restapi/v2.1") == "account-d.docusign.com"
      assert Environment.determine_hostname("https://na3.docusign.net/restapi/v2") == "account.docusign.com"
    end

    test "handles URLs without protocol as production (matches Ruby client behavior)" do
      # Ruby client only checks for URLs starting with specific protocol patterns
      assert Environment.determine_hostname("demo.docusign.net") == "account.docusign.com"
      assert Environment.determine_hostname("apps-d.docusign.com") == "account.docusign.com"
      assert Environment.determine_hostname("na3.docusign.net") == "account.docusign.com"
    end
  end

  describe "detect_environment/1" do
    test "detects sandbox environment" do
      assert Environment.detect_environment("https://demo.docusign.net/restapi") == :sandbox
      assert Environment.detect_environment("https://apps-d.docusign.com") == :sandbox
      assert Environment.detect_environment("http://demo.docusign.net") == :sandbox
    end

    test "detects production environment" do
      assert Environment.detect_environment("https://na3.docusign.net/restapi") == :production
      assert Environment.detect_environment("https://eu.docusign.net/restapi") == :production
      assert Environment.detect_environment("https://www.docusign.net") == :production
    end
  end

  describe "sandbox_environment?/1" do
    test "returns true for exact sandbox patterns (matches Ruby client)" do
      assert Environment.sandbox_environment?("https://demo.docusign.net")
      assert Environment.sandbox_environment?("http://demo.docusign.net")
      assert Environment.sandbox_environment?("https://apps-d.docusign.com")
      assert Environment.sandbox_environment?("http://apps-d.docusign.com")
    end

    test "returns false for URLs without protocol (matches Ruby client)" do
      # Ruby client only checks start_with patterns with protocol
      refute Environment.sandbox_environment?("demo.docusign.net")
      refute Environment.sandbox_environment?("apps-d.docusign.com")
    end

    test "returns false for production patterns" do
      refute Environment.sandbox_environment?("https://na3.docusign.net")
      refute Environment.sandbox_environment?("https://eu.docusign.net")
      refute Environment.sandbox_environment?("https://www.docusign.net")
      refute Environment.sandbox_environment?("https://production.docusign.net")
      refute Environment.sandbox_environment?("na3.docusign.net")
    end

    test "returns false for URLs with demo or apps-d in path but not matching start pattern" do
      # Ruby client uses start_with, so these should be production
      refute Environment.sandbox_environment?("https://na3.docusign.net/demo/restapi")
      refute Environment.sandbox_environment?("https://production.docusign.net/apps-d/test")
    end

    test "returns true for URLs with demo or apps-d subdomains that match start pattern" do
      assert Environment.sandbox_environment?("https://demo-api.docusign.net")
      assert Environment.sandbox_environment?("https://apps-d-test.docusign.com")
    end

    test "case sensitivity matches Ruby client behavior" do
      # Ruby client appears to be case sensitive, so test exact matches
      assert Environment.sandbox_environment?("https://demo.docusign.net")
      assert Environment.sandbox_environment?("https://apps-d.docusign.com")

      # These won't match because Ruby uses exact string start_with
      refute Environment.sandbox_environment?("HTTPS://DEMO.DOCUSIGN.NET")
      refute Environment.sandbox_environment?("https://DEMO.docusign.net")
    end
  end

  describe "oauth_config/2" do
    test "returns complete OAuth configuration for sandbox" do
      config = Environment.oauth_config("https://demo.docusign.net/restapi")

      assert config[:hostname] == "account-d.docusign.com"
      assert config[:environment] == :sandbox
    end

    test "returns complete OAuth configuration for production" do
      config = Environment.oauth_config("https://na3.docusign.net/restapi")

      assert config[:hostname] == "account.docusign.com"
      assert config[:environment] == :production
    end

    test "merges additional options" do
      config =
        Environment.oauth_config(
          "https://demo.docusign.net/restapi",
          client_id: "abc123",
          client_secret: "secret"
        )

      assert config[:hostname] == "account-d.docusign.com"
      assert config[:environment] == :sandbox
      assert config[:client_id] == "abc123"
      assert config[:client_secret] == "secret"
    end

    test "preserves option order with environment config first" do
      config =
        Environment.oauth_config(
          "https://demo.docusign.net/restapi",
          client_id: "abc123"
        )

      [first, second, third] = config
      assert first == {:hostname, "account-d.docusign.com"}
      assert second == {:environment, :sandbox}
      assert third == {:client_id, "abc123"}
    end
  end

  describe "validate_hostname/2" do
    test "validates correct sandbox hostname" do
      assert Environment.validate_hostname(
               "https://demo.docusign.net/restapi",
               "account-d.docusign.com"
             ) == {:ok, "account-d.docusign.com"}
    end

    test "validates correct production hostname" do
      assert Environment.validate_hostname(
               "https://na3.docusign.net/restapi",
               "account.docusign.com"
             ) == {:ok, "account.docusign.com"}
    end

    test "detects environment mismatch for sandbox URL with production hostname" do
      assert Environment.validate_hostname(
               "https://demo.docusign.net/restapi",
               "account.docusign.com"
             ) == {:error, :environment_mismatch}
    end

    test "detects environment mismatch for production URL with sandbox hostname" do
      assert Environment.validate_hostname(
               "https://na3.docusign.net/restapi",
               "account-d.docusign.com"
             ) == {:error, :environment_mismatch}
    end
  end
end
