defmodule DocuSign.DebugTest do
  use ExUnit.Case, async: true

  alias DocuSign.Debug

  describe "enable_debugging/0" do
    test "sets debugging to true in application config" do
      Debug.enable_debugging()
      assert Application.get_env(:docusign, :debugging) == true
    end
  end

  describe "disable_debugging/0" do
    test "sets debugging to false in application config" do
      Debug.disable_debugging()
      assert Application.get_env(:docusign, :debugging) == false
    end
  end

  describe "debugging_enabled?/0" do
    test "returns true when debugging is enabled" do
      Application.put_env(:docusign, :debugging, true)
      assert Debug.debugging_enabled?() == true
    end

    test "returns false when debugging is disabled" do
      Application.put_env(:docusign, :debugging, false)
      assert Debug.debugging_enabled?() == false
    end

    test "returns false when debugging config is not set" do
      Application.delete_env(:docusign, :debugging)
      assert Debug.debugging_enabled?() == false
    end
  end

  describe "filter_headers/0" do
    test "returns default filter headers when not configured" do
      Application.delete_env(:docusign, :debug_filter_headers)
      assert Debug.filter_headers() == ["authorization"]
    end

    test "returns configured filter headers" do
      custom_headers = ["authorization", "x-api-key", "x-custom-secret"]
      Application.put_env(:docusign, :debug_filter_headers, custom_headers)
      assert Debug.filter_headers() == custom_headers
    end
  end

  describe "sdk_headers/0" do
    test "returns SDK identification headers" do
      headers = Debug.sdk_headers()

      assert is_list(headers)
      assert length(headers) == 2

      # Check for X-DocuSign-SDK header
      assert {"X-DocuSign-SDK", sdk_header} = List.keyfind(headers, "X-DocuSign-SDK", 0)
      assert sdk_header =~ ~r/^Elixir\/\d+\.\d+\.\d+/

      # Check for User-Agent header
      assert {"User-Agent", user_agent} = List.keyfind(headers, "User-Agent", 0)
      assert user_agent =~ ~r/^DocuSign-Elixir\/\d+\.\d+\.\d+/
    end
  end

  describe "middleware compatibility" do
    test "middleware/0 returns empty list (deprecated)" do
      Application.put_env(:docusign, :debugging, true)
      assert Debug.middleware() == []

      Application.put_env(:docusign, :debugging, false)
      assert Debug.middleware() == []
    end

    test "all_middleware/0 returns empty list (deprecated)" do
      Application.put_env(:docusign, :debugging, true)
      assert Debug.all_middleware() == []

      Application.put_env(:docusign, :debugging, false)
      assert Debug.all_middleware() == []
    end
  end

  describe "SDK headers format" do
    test "SDK headers are properly formatted" do
      headers = Debug.sdk_headers()

      # Verify header format matches Ruby client expectations
      {"X-DocuSign-SDK", sdk_value} = List.keyfind(headers, "X-DocuSign-SDK", 0)
      assert String.starts_with?(sdk_value, "Elixir/")

      {"User-Agent", ua_value} = List.keyfind(headers, "User-Agent", 0)
      assert String.starts_with?(ua_value, "DocuSign-Elixir/")
    end
  end

  describe "configuration scenarios" do
    test "runtime configuration changes are reflected immediately" do
      # Start with debugging disabled
      Debug.disable_debugging()
      assert Debug.debugging_enabled?() == false

      # Enable debugging
      Debug.enable_debugging()
      assert Debug.debugging_enabled?() == true

      # Disable again
      Debug.disable_debugging()
      assert Debug.debugging_enabled?() == false
    end

    test "custom filter headers work correctly" do
      # Set custom filter headers
      Application.put_env(:docusign, :debug_filter_headers, ["custom-header"])
      assert Debug.filter_headers() == ["custom-header"]

      # Reset to default
      Application.delete_env(:docusign, :debug_filter_headers)
      assert Debug.filter_headers() == ["authorization"]
    end
  end
end
