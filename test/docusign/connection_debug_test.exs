defmodule DocuSign.ConnectionDebugTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureLog

  alias DocuSign.Connection
  alias Plug.Conn

  @moduletag :capture_log

  @access_token "tok-SECRET-abc123"
  @response_token "tok-RESPONSE-SECRET-def456"
  @request_secret "request-custom-SECRET"
  @response_secret "response-custom-SECRET"
  @request_body "PRIVATE-REQUEST signer@example.com"
  @response_body "PRIVATE-RESPONSE document content"

  setup do
    original_config =
      Map.new([:debug, :debug_body, :debug_filter_headers], fn key ->
        {key, Application.fetch_env(:docusign, key)}
      end)

    original_level = Logger.level()
    Logger.configure(level: :debug)

    Application.delete_env(:docusign, :debug_body)
    Application.delete_env(:docusign, :debug_filter_headers)

    on_exit(fn ->
      Enum.each(original_config, fn
        {key, {:ok, value}} -> Application.put_env(:docusign, key, value)
        {key, :error} -> Application.delete_env(:docusign, key)
      end)

      Logger.configure(level: original_level)
    end)
  end

  describe "debug logging through the Req pipeline" do
    test "debug alone logs request details and filtered response headers without bodies" do
      Application.put_env(:docusign, :debug, true)

      log = request_log(debug_connection())

      assert log =~ "[debug] Request: POST https://demo.docusign.net/restapi/envelopes"
      assert log =~ "Request Headers:"
      assert log =~ "Response Status: 201"
      assert log =~ "Response Headers:"
      assert log =~ ~s("authorization" => "[FILTERED]")
      assert length(Regex.scan(~r/\[FILTERED\]/, log)) == 2
      assert log =~ "x-docusign-sdk"
      refute log =~ @access_token
      refute log =~ @response_token
      refute log =~ "Request Body:"
      refute log =~ "Response Body:"
      refute log =~ @request_body
      refute log =~ @response_body
    end

    test "configured headers are filtered case-insensitively in requests and responses" do
      Application.put_env(:docusign, :debug, true)
      Application.put_env(:docusign, :debug_filter_headers, ["AUTHORIZATION", "X-Custom-Secret"])

      log = request_log(debug_connection())

      assert log =~ ~s("x-custom-secret" => "[FILTERED]")
      assert length(Regex.scan(~r/\[FILTERED\]/, log)) == 4
      refute log =~ @access_token
      refute log =~ @response_token
      refute log =~ @request_secret
      refute log =~ @response_secret
    end

    test "bodies can be enabled per request" do
      Application.put_env(:docusign, :debug, true)

      log = request_log(debug_connection(), debug_body: true, json: %{signer: @request_body})

      assert log =~ "Request Body:"
      assert log =~ "Response Body:"
      assert log =~ @request_body
      assert log =~ @response_body
      refute log =~ @access_token
      refute log =~ @response_token
    end

    test "body configuration can be overridden per request" do
      Application.put_env(:docusign, :debug, true)
      Application.put_env(:docusign, :debug_body, true)
      conn = debug_connection()

      log = request_log(conn)
      assert log =~ @request_body
      assert log =~ @response_body

      log = request_log(conn, debug_body: false)
      refute log =~ "Request Body:"
      refute log =~ "Response Body:"
      refute log =~ @request_body
      refute log =~ @response_body
    end

    test "header logging can be disabled per request while keeping method, URL and status" do
      Application.put_env(:docusign, :debug, true)

      log = request_log(debug_connection(), debug_headers: false)

      assert log =~ "Request: POST https://demo.docusign.net/restapi/envelopes"
      assert log =~ "Response Status: 201"
      refute log =~ "Request Headers:"
      refute log =~ "Response Headers:"
      refute log =~ @access_token
      refute log =~ @response_token
    end

    test "debug disabled produces no debug output even with body configuration enabled" do
      Application.put_env(:docusign, :debug, false)
      Application.put_env(:docusign, :debug_body, true)

      assert request_log(debug_connection()) == ""
    end
  end

  describe "Req client debug integration" do
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

  defp debug_connection do
    oauth_client = %OAuth2.Client{
      token: %OAuth2.AccessToken{access_token: @access_token, token_type: "Bearer"}
    }

    {:ok, conn} =
      Connection.from_oauth_client(oauth_client,
        account_id: "test-account",
        base_uri: "https://demo.docusign.net/restapi"
      )

    plug = fn conn ->
      assert Conn.get_req_header(conn, "authorization") == ["Bearer #{@access_token}"]
      assert Conn.get_req_header(conn, "x-custom-secret") == [@request_secret]

      conn
      |> Conn.put_resp_header("authorization", "Bearer #{@response_token}")
      |> Conn.put_resp_header("x-custom-secret", @response_secret)
      |> Conn.send_resp(201, @response_body)
    end

    %{conn | req: Req.merge(conn.req, plug: plug)}
  end

  defp request_log(conn, opts \\ []) do
    capture_log([level: :debug], fn ->
      opts =
        Keyword.merge(
          [
            method: :post,
            url: "/envelopes",
            headers: [{"X-Custom-Secret", @request_secret}],
            body: JSON.encode!(%{signer: @request_body})
          ],
          opts
        )

      assert {:ok, %Req.Response{status: 201}} = Connection.request(conn, opts)
    end)
  end
end
