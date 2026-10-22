defmodule DocuSign.ConnectionRetryTest do
  use ExUnit.Case, async: false

  setup do
    server = DocuSign.TestHTTPServer.open()
    previous_retry_options = Application.get_env(:docusign, :retry_options)

    on_exit(fn ->
      if is_nil(previous_retry_options) do
        Application.delete_env(:docusign, :retry_options)
      else
        Application.put_env(:docusign, :retry_options, previous_retry_options)
      end
    end)

    {:ok, server: server}
  end

  describe "retry configuration" do
    @tag capture_log: true
    test "retries on transient failures", %{server: server} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 2,
        backoff_factor: 1,
        max_delay: 100
      )

      conn = build_connection(server)
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      DocuSign.TestHTTPServer.expect(server, "GET", "/test", fn conn ->
        count = Agent.get_and_update(agent, fn c -> {c, c + 1} end)

        case count do
          0 ->
            Plug.Conn.resp(conn, 500, "Server Error")

          1 ->
            Plug.Conn.resp(conn, 503, "Service Unavailable")

          2 ->
            conn
            |> Plug.Conn.put_resp_header("content-type", "application/json")
            |> Plug.Conn.resp(200, ~s({"success": true}))
        end
      end)

      assert {:ok, response} =
               DocuSign.Connection.request(conn,
                 method: :get,
                 url: "/test"
               )

      assert response.status == 200
      assert response.body == %{"success" => true}
      assert Agent.get(agent, & &1) == 3
    end

    @tag capture_log: true
    test "caps a Retry-After delay at max_delay", %{server: server} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 150
      )

      conn = build_connection(server)
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      DocuSign.TestHTTPServer.expect(server, "GET", "/test", fn conn ->
        case Agent.get_and_update(agent, fn c -> {c, c + 1} end) do
          0 ->
            conn
            |> Plug.Conn.put_resp_header("retry-after", "1")
            |> Plug.Conn.resp(429, "Rate Limited")

          1 ->
            conn
            |> Plug.Conn.put_resp_header("content-type", "application/json")
            |> Plug.Conn.resp(200, ~s({"success": true}))
        end
      end)

      started_at = System.monotonic_time(:millisecond)

      assert {:ok, %{status: 200}} =
               DocuSign.Connection.request(conn, method: :get, url: "/test")

      elapsed = System.monotonic_time(:millisecond) - started_at
      assert elapsed >= 100
      assert elapsed < 800
    end

    @tag capture_log: true
    test "falls back to backoff for a malformed Retry-After header", %{server: server} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 150
      )

      conn = build_connection(server)
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      DocuSign.TestHTTPServer.expect(server, "GET", "/test", fn conn ->
        case Agent.get_and_update(agent, fn c -> {c, c + 1} end) do
          0 ->
            conn
            |> Plug.Conn.put_resp_header("retry-after", "nonsense")
            |> Plug.Conn.resp(429, "Rate Limited")

          1 ->
            Plug.Conn.resp(conn, 200, ~s({"success": true}))
        end
      end)

      started_at = System.monotonic_time(:millisecond)

      assert {:ok, %{status: 200}} =
               DocuSign.Connection.request(conn, method: :get, url: "/test")

      elapsed = System.monotonic_time(:millisecond) - started_at
      assert elapsed >= 100
      assert elapsed < 800
      assert Agent.get(agent, & &1) == 2
    end

    @tag capture_log: true
    test "handles future and past HTTP-date Retry-After values", %{server: server} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 150
      )

      conn = build_connection(server)
      {:ok, agent} = Agent.start_link(fn -> 0 end)
      future = retry_after_date(1)
      past = retry_after_date(-1)

      DocuSign.TestHTTPServer.expect(server, "GET", "/future", fn conn ->
        case Agent.get_and_update(agent, fn c -> {c, c + 1} end) do
          0 ->
            conn
            |> Plug.Conn.put_resp_header("retry-after", future)
            |> Plug.Conn.resp(429, "Rate Limited")

          1 ->
            Plug.Conn.resp(conn, 200, "ok")
        end
      end)

      assert {:ok, %{status: 200}} =
               DocuSign.Connection.request(conn, method: :get, url: "/future")

      DocuSign.TestHTTPServer.expect(server, "GET", "/past", fn conn ->
        case Agent.get_and_update(agent, fn c -> {c, c + 1} end) do
          2 ->
            conn
            |> Plug.Conn.put_resp_header("retry-after", past)
            |> Plug.Conn.resp(429, "Rate Limited")

          3 ->
            Plug.Conn.resp(conn, 200, "ok")
        end
      end)

      started_at = System.monotonic_time(:millisecond)

      assert {:ok, %{status: 200}} =
               DocuSign.Connection.request(conn, method: :get, url: "/past")

      elapsed = System.monotonic_time(:millisecond) - started_at
      assert elapsed < 500
      assert Agent.get(agent, & &1) == 4
    end

    @tag capture_log: true
    test "falls back to backoff for a negative Retry-After value", %{server: server} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 150
      )

      conn = build_connection(server)
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      DocuSign.TestHTTPServer.expect(server, "GET", "/test", fn conn ->
        case Agent.get_and_update(agent, fn c -> {c, c + 1} end) do
          0 ->
            conn
            |> Plug.Conn.put_resp_header("retry-after", "-1")
            |> Plug.Conn.resp(429, "Rate Limited")

          1 ->
            Plug.Conn.resp(conn, 200, "ok")
        end
      end)

      started_at = System.monotonic_time(:millisecond)

      assert {:ok, %{status: 200}} =
               DocuSign.Connection.request(conn, method: :get, url: "/test")

      elapsed = System.monotonic_time(:millisecond) - started_at
      assert elapsed >= 100
      assert elapsed < 800
    end

    @tag capture_log: true
    test "handles rate limits with Retry-After telemetry", %{server: server} do
      attach_rate_limit_handler()

      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 100
      )

      conn = build_connection(server)
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      DocuSign.TestHTTPServer.expect(server, "GET", "/with-header", fn conn ->
        case Agent.get_and_update(agent, fn c -> {c, c + 1} end) do
          0 ->
            conn
            |> Plug.Conn.put_resp_header("retry-after", "1")
            |> Plug.Conn.resp(429, "Rate Limited")

          1 ->
            Plug.Conn.resp(conn, 200, "ok")
        end
      end)

      assert {:ok, %{status: 200}} =
               DocuSign.Connection.request(conn, method: :get, url: "/with-header")

      assert_receive {
                       :rate_limit,
                       [:docusign, :rate_limit, :hit],
                       %{retry_after: 1},
                       %{account_id: "test-account"}
                     },
                     1_000

      refute_receive {:rate_limit, [:docusign, :rate_limit, :hit], _, _}, 50
    end

    @tag capture_log: true
    test "does not emit rate-limit telemetry for a 503", %{server: server} do
      attach_rate_limit_handler()

      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 100
      )

      conn = build_connection(server)

      DocuSign.TestHTTPServer.expect(server, "GET", "/test", fn conn ->
        conn
        |> Plug.Conn.put_resp_header("retry-after", "0")
        |> Plug.Conn.resp(503, "Service Unavailable")
      end)

      assert {:error, {:http_error, 503, "Service Unavailable"}} =
               DocuSign.Connection.request(conn, method: :get, url: "/test")

      refute_receive {:rate_limit, [:docusign, :rate_limit, :hit], _, _}, 100
    end

    @tag capture_log: true
    test "emits rate-limit telemetry with nil for a 429 without Retry-After", %{server: server} do
      attach_rate_limit_handler()

      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 100
      )

      conn = build_connection(server)
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      DocuSign.TestHTTPServer.expect(server, "GET", "/test", fn conn ->
        case Agent.get_and_update(agent, fn c -> {c, c + 1} end) do
          0 ->
            Plug.Conn.resp(conn, 429, "Rate Limited")

          1 ->
            Plug.Conn.resp(conn, 200, "ok")
        end
      end)

      assert {:ok, %{status: 200}} =
               DocuSign.Connection.request(conn, method: :get, url: "/test")

      assert_receive {
                       :rate_limit,
                       [:docusign, :rate_limit, :hit],
                       %{retry_after: nil},
                       %{account_id: "test-account"}
                     },
                     1_000

      refute_receive {:rate_limit, [:docusign, :rate_limit, :hit], _, _}, 50
    end

    test "disables retry when configured", %{server: server} do
      Application.put_env(:docusign, :retry_options, enabled: false)
      conn = build_connection(server)

      DocuSign.TestHTTPServer.expect_once(server, "GET", "/test", fn conn ->
        Plug.Conn.resp(conn, 500, "Server Error")
      end)

      assert {:error, {:http_error, 500, "Server Error"}} =
               DocuSign.Connection.request(conn,
                 method: :get,
                 url: "/test"
               )
    end

    @tag capture_log: true
    test "respects max_retries configuration", %{server: server} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 100
      )

      conn = build_connection(server)
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      DocuSign.TestHTTPServer.expect(server, "GET", "/test", fn conn ->
        Agent.update(agent, &(&1 + 1))
        Plug.Conn.resp(conn, 500, "Server Error")
      end)

      assert {:error, {:http_error, 500, "Server Error"}} =
               DocuSign.Connection.request(conn,
                 method: :get,
                 url: "/test"
               )

      assert Agent.get(agent, & &1) == 2
    end

    @tag capture_log: true
    test "applies exponential backoff within max_delay", %{server: server} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 2,
        backoff_factor: 2,
        max_delay: 150
      )

      conn = build_connection(server)
      {:ok, agent} = Agent.start_link(fn -> [] end)

      DocuSign.TestHTTPServer.expect(server, "GET", "/test", fn conn ->
        timestamp = System.monotonic_time(:millisecond)
        Agent.update(agent, &(&1 ++ [timestamp]))

        if length(Agent.get(agent, & &1)) < 3 do
          Plug.Conn.resp(conn, 500, "Server Error")
        else
          Plug.Conn.resp(conn, 200, ~s({"success": true}))
        end
      end)

      assert {:ok, _response} =
               DocuSign.Connection.request(conn,
                 method: :get,
                 url: "/test"
               )

      [first, second, third] = Agent.get(agent, & &1)
      assert second - first >= 100
      assert third - second >= 100
      assert third - first < 800
    end
  end

  defp build_connection(server) do
    {:ok, conn} =
      DocuSign.Connection.from_oauth_client(
        OAuth2.Client.new(token: "test-token"),
        account_id: "test-account",
        base_uri: "http://localhost:#{server.port}"
      )

    conn
  end

  defp retry_after_date(offset_seconds) do
    now = :calendar.universal_time()
    seconds = :calendar.datetime_to_gregorian_seconds(now) + offset_seconds

    seconds
    |> :calendar.gregorian_seconds_to_datetime()
    |> :httpd_util.rfc1123_date()
    |> List.to_string()
  end

  defp attach_rate_limit_handler do
    test_pid = self()
    handler_id = "rate-limit-handler-#{System.unique_integer()}"

    :telemetry.attach(
      handler_id,
      [:docusign, :rate_limit, :hit],
      fn event, measurements, metadata, _config ->
        send(test_pid, {:rate_limit, event, measurements, metadata})
      end,
      nil
    )

    on_exit(fn -> :telemetry.detach(handler_id) end)
  end
end
