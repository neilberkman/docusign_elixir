defmodule DocuSign.DebugTest do
  use ExUnit.Case, async: true

  alias DocuSign.Debug
  alias Tesla.Middleware.BaseUrl
  alias Tesla.Middleware.Headers
  alias Tesla.Middleware.Logger

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

  describe "middleware/0" do
    test "returns logger middleware when debugging is enabled" do
      Application.put_env(:docusign, :debugging, true)
      Application.put_env(:docusign, :debug_filter_headers, ["auth"])

      middleware = Debug.middleware()

      assert length(middleware) == 1
      assert {Logger, opts} = hd(middleware)
      assert opts[:debug] == true
      assert opts[:filter_headers] == ["auth"]
      assert opts[:format] == "$method $url -> $status ($time ms)"
    end

    test "returns empty list when debugging is disabled" do
      Application.put_env(:docusign, :debugging, false)
      assert Debug.middleware() == []
    end

    test "returns empty list when debugging is not configured" do
      Application.delete_env(:docusign, :debugging)
      assert Debug.middleware() == []
    end
  end

  describe "sdk_headers/0" do
    test "returns SDK identification headers" do
      headers = Debug.sdk_headers()

      assert length(headers) == 1
      assert {Headers, header_list} = hd(headers)

      # Check for X-DocuSign-SDK header
      assert {"X-DocuSign-SDK", sdk_header} = List.keyfind(header_list, "X-DocuSign-SDK", 0)
      assert sdk_header =~ ~r/^Elixir\/\d+\.\d+\.\d+/

      # Check for User-Agent header
      assert {"User-Agent", user_agent} = List.keyfind(header_list, "User-Agent", 0)
      assert user_agent =~ ~r/^DocuSign-Elixir\/\d+\.\d+\.\d+/
    end
  end

  describe "all_middleware/0" do
    test "returns SDK headers plus debugging middleware when enabled" do
      Application.put_env(:docusign, :debugging, true)

      middleware = Debug.all_middleware()

      # Should have SDK headers + debug middleware
      assert length(middleware) == 2

      # First should be SDK headers
      assert {Headers, _} = Enum.at(middleware, 0)

      # Second should be debug logger
      assert {Logger, _} = Enum.at(middleware, 1)
    end

    test "returns only SDK headers when debugging is disabled" do
      Application.put_env(:docusign, :debugging, false)

      middleware = Debug.all_middleware()

      # Should have only SDK headers
      assert length(middleware) == 1
      assert {Headers, _} = hd(middleware)
    end
  end

  describe "integration with Tesla" do
    test "middleware can be used to build Tesla client" do
      Application.put_env(:docusign, :debugging, true)

      middleware =
        [
          {BaseUrl, "https://demo.docusign.net/restapi"},
          {Headers, [{"authorization", "Bearer test-token"}]}
        ] ++ Debug.all_middleware()

      # Should not raise any errors
      client = Tesla.client(middleware)
      assert %Tesla.Client{} = client
    end

    test "SDK headers are properly formatted" do
      headers_middleware = Debug.sdk_headers()
      assert [{Headers, headers}] = headers_middleware

      # Verify header format matches Ruby client expectations
      sdk_header = List.keyfind(headers, "X-DocuSign-SDK", 0)
      assert {"X-DocuSign-SDK", value} = sdk_header
      assert String.starts_with?(value, "Elixir/")

      user_agent = List.keyfind(headers, "User-Agent", 0)
      assert {"User-Agent", value} = user_agent
      assert String.starts_with?(value, "DocuSign-Elixir/")
    end
  end

  describe "configuration scenarios" do
    setup do
      # Save original config
      original_debugging = Application.get_env(:docusign, :debugging)
      original_filter_headers = Application.get_env(:docusign, :debug_filter_headers)

      on_exit(fn ->
        # Restore original config
        if original_debugging do
          Application.put_env(:docusign, :debugging, original_debugging)
        else
          Application.delete_env(:docusign, :debugging)
        end

        if original_filter_headers do
          Application.put_env(:docusign, :debug_filter_headers, original_filter_headers)
        else
          Application.delete_env(:docusign, :debug_filter_headers)
        end
      end)
    end

    test "runtime configuration changes are reflected immediately" do
      # Start with debugging disabled
      Debug.disable_debugging()
      refute Debug.debugging_enabled?()
      assert Debug.middleware() == []

      # Enable debugging at runtime
      Debug.enable_debugging()
      assert Debug.debugging_enabled?()
      assert length(Debug.middleware()) == 1

      # Disable again
      Debug.disable_debugging()
      refute Debug.debugging_enabled?()
      assert Debug.middleware() == []
    end

    test "custom filter headers work correctly" do
      Application.put_env(:docusign, :debugging, true)
      custom_headers = ["authorization", "x-secret", "x-token"]
      Application.put_env(:docusign, :debug_filter_headers, custom_headers)

      assert Debug.filter_headers() == custom_headers

      [{Logger, opts}] = Debug.middleware()
      assert opts[:filter_headers] == custom_headers
    end
  end
end
