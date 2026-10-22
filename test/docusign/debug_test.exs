defmodule DocuSign.DebugTest do
  use ExUnit.Case, async: false

  alias DocuSign.Debug

  # Suppress deprecation warnings for testing deprecated functions
  @compile {:no_warn_deprecated_function, {DocuSign.Debug, :middleware, 0}}
  @compile {:no_warn_deprecated_function, {DocuSign.Debug, :all_middleware, 0}}

  setup do
    original_config =
      Map.new([:debug, :debug_filter_headers], fn key ->
        {key, Application.fetch_env(:docusign, key)}
      end)

    on_exit(fn ->
      Enum.each(original_config, fn
        {key, {:ok, value}} -> Application.put_env(:docusign, key, value)
        {key, :error} -> Application.delete_env(:docusign, key)
      end)
    end)
  end

  describe "enable_debugging/0" do
    test "sets debug to true in application config" do
      Debug.enable_debugging()
      assert Application.get_env(:docusign, :debug) == true
    end
  end

  describe "disable_debugging/0" do
    test "sets debug to false in application config" do
      Debug.disable_debugging()
      assert Application.get_env(:docusign, :debug) == false
    end
  end

  describe "debugging_enabled?/0" do
    test "returns true when debugging is enabled" do
      Application.put_env(:docusign, :debug, true)
      assert Debug.debugging_enabled?() == true
    end

    test "returns false when debugging is disabled" do
      Application.put_env(:docusign, :debug, false)
      assert Debug.debugging_enabled?() == false
    end

    test "returns false when debugging config is not set" do
      Application.delete_env(:docusign, :debug)
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
    test "returns SDK identification headers as tuples" do
      headers = Debug.sdk_headers()

      assert length(headers) == 2

      # Check for X-DocuSign-SDK header
      assert {"X-DocuSign-SDK", sdk_header} = List.keyfind(headers, "X-DocuSign-SDK", 0)
      assert sdk_header =~ ~r/^Elixir\/\d+\.\d+\.\d+/

      # Check for User-Agent header
      assert {"User-Agent", user_agent} = List.keyfind(headers, "User-Agent", 0)
      assert user_agent =~ ~r/^docusign-elixir\/\d+\.\d+\.\d+/
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
      # Set custom headers
      custom = ["authorization", "x-secret", "api-key"]
      Application.put_env(:docusign, :debug_filter_headers, custom)

      assert Debug.filter_headers() == custom

      # Delete config to use defaults
      Application.delete_env(:docusign, :debug_filter_headers)
      assert Debug.filter_headers() == ["authorization"]
    end
  end
end
