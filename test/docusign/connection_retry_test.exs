defmodule DocuSign.ConnectionRetryTest do
  use ExUnit.Case

  defp decode_json_step({request, response}) do
    case get_content_type(response.headers) do
      content_type when content_type in ["application/json", "text/json"] ->
        case Jason.decode(response.body) do
          {:ok, decoded} -> {request, %{response | body: decoded}}
          {:error, _} -> {request, response}
        end

      _ ->
        {request, response}
    end
  end

  defp get_content_type(headers) when is_map(headers) do
    case Map.get(headers, "content-type") do
      [value | _] -> String.split(value, ";") |> List.first() |> String.trim()
      value when is_binary(value) -> String.split(value, ";") |> List.first() |> String.trim()
      _ -> nil
    end
  end

  defp get_content_type(headers) when is_list(headers) do
    case List.keyfind(headers, "content-type", 0) do
      {"content-type", value} -> String.split(value, ";") |> List.first() |> String.trim()
      _ -> nil
    end
  end

  defp get_content_type(_), do: nil

  setup do
    bypass = Bypass.open()

    # Create a test connection with bypass URL
    req =
      Req.new(
        base_url: "http://localhost:#{bypass.port}",
        headers: [
          {"authorization", "Bearer test-token"},
          {"content-type", "application/json"}
        ]
      )
      |> Req.Request.prepend_response_steps(decode_json: &decode_json_step/1)

    conn = %DocuSign.Connection{
      app_account: %{
        account_id: "test-account",
        base_uri: "http://localhost:#{bypass.port}"
      },
      req: req
    }

    {:ok, bypass: bypass, conn: conn}
  end

  describe "retry configuration" do
    test "retries on transient failures", %{bypass: bypass, conn: conn} do
      # Configure retry with shorter delays for testing
      Application.put_env(:docusign, :retry_options,
        max_retries: 2,
        backoff_factor: 1,
        max_delay: 100
      )

      # First two attempts fail with 500, third succeeds
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      Bypass.expect(bypass, "GET", "/test", fn conn ->
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

      # Rebuild connection with retry config
      req = configure_retry_for_test(conn.req)
      updated_conn = %{conn | req: req}

      # Should eventually succeed after retries
      assert {:ok, response} =
               DocuSign.Connection.request(updated_conn,
                 method: :get,
                 url: "/test"
               )

      assert response.status == 200
      assert response.body == %{"success" => true}

      # Verify all attempts were made
      assert Agent.get(agent, & &1) == 3
    end

    test "handles rate limits with Retry-After header", %{bypass: bypass, conn: conn} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 2,
        backoff_factor: 1,
        max_delay: 100
      )

      {:ok, agent} = Agent.start_link(fn -> 0 end)

      Bypass.expect(bypass, "GET", "/test", fn conn ->
        count = Agent.get_and_update(agent, fn c -> {c, c + 1} end)

        case count do
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

      req = configure_retry_for_test(conn.req)
      updated_conn = %{conn | req: req}

      # Should succeed after respecting Retry-After
      start_time = System.monotonic_time(:millisecond)

      assert {:ok, response} =
               DocuSign.Connection.request(updated_conn,
                 method: :get,
                 url: "/test"
               )

      elapsed = System.monotonic_time(:millisecond) - start_time

      assert response.status == 200
      # Should have waited at least 1 second as specified by Retry-After
      assert elapsed >= 1000
    end

    test "disables retry when configured", %{bypass: bypass, conn: conn} do
      Application.put_env(:docusign, :retry_options, enabled: false)

      Bypass.expect_once(bypass, "GET", "/test", fn conn ->
        Plug.Conn.resp(conn, 500, "Server Error")
      end)

      req = configure_retry_for_test(conn.req)
      updated_conn = %{conn | req: req}

      # Should fail immediately without retry
      assert {:error, {:http_error, 500, "Server Error"}} =
               DocuSign.Connection.request(updated_conn,
                 method: :get,
                 url: "/test"
               )
    end

    test "respects max_retries configuration", %{bypass: bypass, conn: conn} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 100
      )

      {:ok, agent} = Agent.start_link(fn -> 0 end)

      Bypass.expect(bypass, "GET", "/test", fn conn ->
        Agent.update(agent, &(&1 + 1))
        Plug.Conn.resp(conn, 500, "Server Error")
      end)

      req = configure_retry_for_test(conn.req)
      updated_conn = %{conn | req: req}

      # Should fail after max_retries attempts
      assert {:error, {:http_error, 500, "Server Error"}} =
               DocuSign.Connection.request(updated_conn,
                 method: :get,
                 url: "/test"
               )

      # Should have made 2 attempts (initial + 1 retry)
      assert Agent.get(agent, & &1) == 2
    end

    test "applies exponential backoff", %{bypass: bypass, conn: conn} do
      Application.put_env(:docusign, :retry_options,
        max_retries: 2,
        backoff_factor: 2,
        max_delay: 5000
      )

      {:ok, agent} = Agent.start_link(fn -> [] end)

      Bypass.expect(bypass, "GET", "/test", fn conn ->
        timestamp = System.monotonic_time(:millisecond)
        Agent.update(agent, &(&1 ++ [timestamp]))

        if length(Agent.get(agent, & &1)) < 3 do
          Plug.Conn.resp(conn, 500, "Server Error")
        else
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/json")
          |> Plug.Conn.resp(200, ~s({"success": true}))
        end
      end)

      req = configure_retry_for_test(conn.req)
      updated_conn = %{conn | req: req}

      assert {:ok, _response} =
               DocuSign.Connection.request(updated_conn,
                 method: :get,
                 url: "/test"
               )

      timestamps = Agent.get(agent, & &1)
      assert length(timestamps) == 3

      # Check delays between attempts (with tolerance for jitter)
      delay1 = Enum.at(timestamps, 1) - Enum.at(timestamps, 0)
      delay2 = Enum.at(timestamps, 2) - Enum.at(timestamps, 1)

      # First retry: ~1-2 seconds (1000ms base + jitter)
      assert delay1 >= 1000 and delay1 <= 2500

      # Second retry: ~2-3 seconds (2000ms base + jitter)
      assert delay2 >= 2000 and delay2 <= 3500

      # Second delay should be roughly double the first (exponential)
      assert delay2 > delay1
    end
  end

  # Private helper to configure retry manually for testing
  defp configure_retry_for_test(req) do
    retry_options = Application.get_env(:docusign, :retry_options, [])

    if retry_options[:enabled] == false do
      Req.merge(req, retry: false)
    else
      max_retries = retry_options[:max_retries] || 3
      backoff_factor = retry_options[:backoff_factor] || 2
      max_delay = retry_options[:max_delay] || 30_000

      req
      |> Req.merge(
        retry: :transient,
        max_retries: max_retries,
        retry_delay: fn attempt ->
          # Ensure non-negative exponent (attempt starts from 0 in Req)
          exponent = max(0, attempt)
          base_delay = Integer.pow(backoff_factor, exponent) * 1000
          jittered = base_delay + :rand.uniform(1000)
          min(jittered, max_delay)
        end
      )
      |> Req.Request.prepend_error_steps(handle_rate_limit: &handle_rate_limit_error_for_test/1)
    end
  end

  defp handle_rate_limit_error_for_test({request, %Req.Response{status: 429} = response}) do
    # Check for Retry-After header
    retry_after = get_retry_after_for_test(response.headers)

    if retry_after && request.private[:retry_count] < request.options[:max_retries] do
      # Wait for the specified time before retrying
      Process.sleep(retry_after * 1000)
      {request, {:retry, response}}
    else
      {request, response}
    end
  end

  defp handle_rate_limit_error_for_test({request, response_or_error}) do
    {request, response_or_error}
  end

  defp get_retry_after_for_test(headers) do
    case List.keyfind(headers, "retry-after", 0) do
      {"retry-after", value} when is_list(value) ->
        value |> List.first() |> parse_retry_after_for_test()

      {"retry-after", value} when is_binary(value) ->
        parse_retry_after_for_test(value)

      _ ->
        nil
    end
  end

  defp parse_retry_after_for_test(value) when is_binary(value) do
    case Integer.parse(value) do
      {seconds, ""} -> seconds
      _ -> nil
    end
  end

  defp parse_retry_after_for_test(_), do: nil
end
