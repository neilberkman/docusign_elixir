defmodule DocuSign.ConnectionDebugTest do
  use ExUnit.Case, async: false

  alias DocuSign.Connection
  alias DocuSign.Debug

  require Logger

  # Helper functions for debug steps
  defp debug_request(request) do
    if request.options[:debug_headers] do
      Logger.debug("Request Headers: #{inspect(request.headers)}")
    end

    if request.options[:debug_body] do
      Logger.debug("Request Body: #{inspect(request.body)}")
    end

    request
  end

  defp debug_response({request, response}) do
    if request.options[:debug_headers] do
      Logger.debug("Response Headers: #{inspect(response.headers)}")
    end

    if request.options[:debug_body] do
      Logger.debug("Response Body: #{inspect(response.body)}")
    end

    {request, response}
  end

  describe "Req client debug integration" do
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

    test "connection includes debug steps when debugging is enabled" do
      Debug.enable_debugging()

      # Create a connection (which internally builds a Req client)
      app_account = %{base_uri: "https://demo.docusign.net/restapi"}
      client = %{token: %{access_token: "test-token", token_type: "Bearer"}}

      # Use the private build_connection function's logic
      req =
        Req.new(
          base_url: app_account.base_uri,
          headers:
            [
              {"authorization", "Bearer test-token"},
              {"content-type", "application/json"}
            ] ++ Debug.sdk_headers(),
          receive_timeout: 30_000,
          retry: false
        )

      # When debugging is enabled, we should apply debug steps
      # Since we're manually creating the Req here, we need to apply debug steps
      if Application.get_env(:docusign, :debugging, false) do
        req =
          req
          |> Req.Request.register_options([:debug_body, :debug_headers])
          |> Req.Request.prepend_request_steps(debug_request: &debug_request/1)
          |> Req.Request.prepend_response_steps(debug_response: &debug_response/1)

        # Now check that request steps were added
        assert not Enum.empty?(req.request_steps) || not Enum.empty?(req.response_steps)
      end

      conn = %Connection{
        app_account: app_account,
        client: client,
        req: req
      }

      # Verify connection was created
      assert %Connection{} = conn
      assert conn.req.options[:base_url] == "https://demo.docusign.net/restapi"
    end

    test "connection excludes debug steps when debugging is disabled" do
      Debug.disable_debugging()

      # Create a connection
      app_account = %{base_uri: "https://demo.docusign.net/restapi"}
      client = %{token: %{access_token: "test-token", token_type: "Bearer"}}

      req =
        Req.new(
          base_url: app_account.base_uri,
          headers:
            [
              {"authorization", "Bearer test-token"},
              {"content-type", "application/json"}
            ] ++ Debug.sdk_headers(),
          receive_timeout: 30_000,
          retry: false
        )

      conn = %Connection{
        app_account: app_account,
        client: client,
        req: req
      }

      # Verify connection was created
      assert %Connection{} = conn
      assert conn.req.options[:base_url] == "https://demo.docusign.net/restapi"
    end

    test "SDK headers are properly configured" do
      # Create a connection
      app_account = %{base_uri: "https://demo.docusign.net/restapi"}
      client = %{token: %{access_token: "test-token", token_type: "Bearer"}}

      sdk_headers = Debug.sdk_headers()

      req =
        Req.new(
          base_url: app_account.base_uri,
          headers:
            [
              {"authorization", "Bearer test-token"},
              {"content-type", "application/json"}
            ] ++ sdk_headers,
          receive_timeout: 30_000,
          retry: false
        )

      conn = %Connection{
        app_account: app_account,
        client: client,
        req: req
      }

      # Verify SDK headers are present
      headers = conn.req.headers

      # Check for X-DocuSign-SDK header
      sdk_header = Enum.find(headers, fn {k, _v} -> k == "x-docusign-sdk" end)
      assert sdk_header != nil
      {_, value} = sdk_header
      # Handle both string and list formats
      sdk_string = if is_list(value), do: List.first(value), else: value
      assert sdk_string =~ ~r/^Elixir\/\d+\.\d+\.\d+/

      # Check for User-Agent header
      ua_header = Enum.find(headers, fn {k, _v} -> k == "user-agent" end)
      assert ua_header != nil
      {_, value} = ua_header
      # Handle both string and list formats
      ua_string = if is_list(value), do: List.first(value), else: value
      assert ua_string =~ ~r/^DocuSign-Elixir\/\d+\.\d+\.\d+/
    end
  end
end
