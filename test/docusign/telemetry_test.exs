defmodule DocuSign.TelemetryTest do
  use ExUnit.Case, async: false

  alias DocuSign.Telemetry

  setup do
    bypass = Bypass.open()

    # Create a test connection
    req =
      Req.new(
        base_url: "http://localhost:#{bypass.port}",
        headers: [
          {"authorization", "Bearer test-token"},
          {"content-type", "application/json"}
        ]
      )

    conn = %DocuSign.Connection{
      app_account: %{
        account_id: "test-account-123",
        base_uri: "http://localhost:#{bypass.port}"
      },
      req: req
    }

    {:ok, bypass: bypass, conn: conn}
  end

  describe "telemetry events" do
    test "emits api start and stop events for successful requests", %{bypass: bypass, conn: conn} do
      # Set up telemetry handler to capture events
      test_pid = self()
      handler_id = "test-handler-#{System.unique_integer()}"

      :telemetry.attach_many(
        handler_id,
        [
          [:docusign, :api, :start],
          [:docusign, :api, :stop]
        ],
        fn event, measurements, metadata, _config ->
          send(test_pid, {:telemetry_event, event, measurements, metadata})
        end,
        nil
      )

      # Mock successful response
      Bypass.expect_once(bypass, "GET", "/v2.1/accounts/test-account-123/envelopes", fn conn ->
        Plug.Conn.resp(conn, 200, ~s({"envelopes": []}))
      end)

      # Make request
      {:ok, _response} =
        DocuSign.Connection.request(conn,
          method: :get,
          url: "/v2.1/accounts/test-account-123/envelopes",
          telemetry_metadata: %{operation: "list_envelopes"}
        )

      # Verify start event
      assert_receive {:telemetry_event, [:docusign, :api, :start], start_measurements, start_metadata},
                     1000

      assert start_measurements[:system_time] != nil
      assert start_metadata[:operation] == "list_envelopes"
      assert start_metadata[:account_id] == "test-account-123"
      assert start_metadata[:method] == :get
      assert start_metadata[:path] == "/v2.1/accounts/test-account-123/envelopes"

      # Verify stop event
      assert_receive {:telemetry_event, [:docusign, :api, :stop], stop_measurements, stop_metadata},
                     1000

      assert stop_measurements[:duration] > 0
      assert stop_metadata[:operation] == "list_envelopes"
      assert stop_metadata[:status] == 200

      # Cleanup
      :telemetry.detach(handler_id)
    end

    test "emits api exception event for connection failures", %{bypass: bypass, conn: conn} do
      handler_id = "test-handler-#{System.unique_integer()}"

      captured_events = :ets.new(:captured_events, [:public, :bag])

      :telemetry.attach(
        handler_id,
        [:docusign, :api, :exception],
        fn event, measurements, metadata, _config ->
          :ets.insert(captured_events, {event, measurements, metadata})
        end,
        nil
      )

      # Stop bypass to force connection error
      Bypass.down(bypass)

      # Make request that will fail due to connection refused
      {:error, _reason} =
        DocuSign.Connection.request(conn,
          method: :get,
          url: "/test"
        )

      # Allow time for async telemetry
      Process.sleep(100)

      # Verify exception event
      events = :ets.tab2list(captured_events)
      assert length(events) == 1

      [{[:docusign, :api, :exception], measurements, metadata}] = events
      assert measurements[:duration] >= 0
      assert metadata[:operation] =~ "test"
      assert metadata[:kind] == :error
      assert metadata[:reason] != nil

      # Cleanup
      :telemetry.detach(handler_id)
      :ets.delete(captured_events)
    end

    @tag :skip
    test "emits rate limit event when hitting 429", %{bypass: bypass, conn: conn} do
      handler_id = "test-handler-#{System.unique_integer()}"

      captured_events = :ets.new(:captured_events, [:public, :bag])

      :telemetry.attach(
        handler_id,
        [:docusign, :rate_limit, :hit],
        fn event, measurements, metadata, _config ->
          :ets.insert(captured_events, {event, measurements, metadata})
        end,
        nil
      )

      # Configure retry to handle rate limit
      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 100
      )

      # Mock rate limit response
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      Bypass.expect(bypass, "GET", "/test", fn conn ->
        count = Agent.get_and_update(agent, fn c -> {c, c + 1} end)

        case count do
          0 ->
            conn
            |> Plug.Conn.put_resp_header("retry-after", "1")
            |> Plug.Conn.resp(429, "Rate Limited")

          1 ->
            Plug.Conn.resp(conn, 200, ~s({"success": true}))
        end
      end)

      # Rebuild connection with retry config using the private function
      updated_conn = rebuild_conn_with_retry(conn)

      # Make request that will hit rate limit then succeed
      # The finch_private metadata needs to be set for rate limit telemetry
      {:ok, _response} =
        DocuSign.Connection.request(updated_conn,
          method: :get,
          url: "/test",
          telemetry_metadata: %{operation: "test_operation"},
          finch_private: %{account_id: "test-account-123", operation: "test_operation"}
        )

      # Allow time for async telemetry
      Process.sleep(100)

      # Verify rate limit event
      events = :ets.tab2list(captured_events)
      assert length(events) == 1

      [{[:docusign, :rate_limit, :hit], measurements, metadata}] = events
      assert measurements[:retry_after] == 1
      assert metadata[:operation] == "test_operation"
      assert metadata[:account_id] == "test-account-123"

      # Cleanup
      :telemetry.detach(handler_id)
      :ets.delete(captured_events)
      Agent.stop(agent)
    end

    test "automatically extracts operation name from path", %{bypass: bypass, conn: conn} do
      handler_id = "test-handler-#{System.unique_integer()}"

      captured_events = :ets.new(:captured_events, [:public, :bag])

      :telemetry.attach(
        handler_id,
        [:docusign, :api, :start],
        fn event, measurements, metadata, _config ->
          :ets.insert(captured_events, {event, measurements, metadata})
        end,
        nil
      )

      # Mock response
      Bypass.expect_once(bypass, "POST", "/v2.1/accounts/123/envelopes", fn conn ->
        Plug.Conn.resp(conn, 201, ~s({"envelopeId": "abc123"}))
      end)

      # Make request without explicit operation name
      {:ok, _response} =
        DocuSign.Connection.request(conn,
          method: :post,
          url: "/v2.1/accounts/123/envelopes",
          body: "{}"
        )

      # Allow time for async telemetry
      Process.sleep(100)

      # Verify operation was extracted
      events = :ets.tab2list(captured_events)
      assert length(events) == 1

      [{[:docusign, :api, :start], _measurements, metadata}] = events
      assert metadata[:operation] == "post_envelopes"

      # Cleanup
      :telemetry.detach(handler_id)
      :ets.delete(captured_events)
    end
  end

  describe "telemetry span" do
    test "wraps operations with start/stop events" do
      handler_id = "test-handler-#{System.unique_integer()}"

      captured_events = :ets.new(:captured_events, [:public, :bag])

      :telemetry.attach_many(
        handler_id,
        [
          [:docusign, :custom, :operation, :start],
          [:docusign, :custom, :operation, :stop]
        ],
        fn event, measurements, metadata, _config ->
          :ets.insert(captured_events, {event, measurements, metadata})
        end,
        nil
      )

      # Use span to wrap an operation
      result =
        Telemetry.span([:docusign, :custom, :operation], %{account_id: "123"}, fn ->
          Process.sleep(10)
          {:ok, "result"}
        end)

      assert result == {:ok, "result"}

      # Verify events
      events = :ets.tab2list(captured_events)
      assert length(events) == 2

      # Find start and stop events
      start_event =
        Enum.find(events, fn {event, _, _} ->
          event == [:docusign, :custom, :operation, :start]
        end)

      stop_event =
        Enum.find(events, fn {event, _, _} ->
          event == [:docusign, :custom, :operation, :stop]
        end)

      assert start_event != nil
      assert stop_event != nil

      {_, _, start_metadata} = start_event
      {_, stop_measurements, stop_metadata} = stop_event

      assert start_metadata[:account_id] == "123"
      assert stop_metadata[:account_id] == "123"
      assert stop_measurements[:duration] > 0

      # Cleanup
      :telemetry.detach(handler_id)
      :ets.delete(captured_events)
    end

    test "emits exception event when operation fails" do
      handler_id = "test-handler-#{System.unique_integer()}"

      captured_events = :ets.new(:captured_events, [:public, :bag])

      :telemetry.attach(
        handler_id,
        [:docusign, :custom, :operation, :exception],
        fn event, measurements, metadata, _config ->
          :ets.insert(captured_events, {event, measurements, metadata})
        end,
        nil
      )

      # Use span with an operation that raises
      assert_raise RuntimeError, "test error", fn ->
        Telemetry.span([:docusign, :custom, :operation], %{account_id: "123"}, fn ->
          raise "test error"
        end)
      end

      # Verify exception event
      events = :ets.tab2list(captured_events)
      assert length(events) == 1

      [{[:docusign, :custom, :operation, :exception], measurements, metadata}] = events
      assert measurements[:duration] >= 0
      assert metadata[:kind] == :error
      assert metadata[:reason].message == "test error"
      assert metadata[:stacktrace] != nil

      # Cleanup
      :telemetry.detach(handler_id)
      :ets.delete(captured_events)
    end
  end

  describe "finch telemetry integration" do
    test "finch events are emitted alongside docusign events", %{bypass: bypass, conn: conn} do
      handler_id = "test-handler-#{System.unique_integer()}"

      captured_events = :ets.new(:captured_events, [:public, :bag])

      :telemetry.attach_many(
        handler_id,
        [
          [:finch, :request, :start],
          [:finch, :request, :stop],
          [:docusign, :api, :start],
          [:docusign, :api, :stop]
        ],
        fn event, measurements, metadata, _config ->
          :ets.insert(captured_events, {event, measurements, metadata})
        end,
        nil
      )

      # Mock response
      Bypass.expect_once(bypass, "GET", "/test", fn conn ->
        Plug.Conn.resp(conn, 200, ~s({"ok": true}))
      end)

      # Make request with finch_private metadata
      {:ok, _response} =
        DocuSign.Connection.request(conn,
          method: :get,
          url: "/test",
          telemetry_metadata: %{operation: "test"}
        )

      # Allow time for async telemetry
      Process.sleep(100)

      # Verify we got both DocuSign and Finch events
      events = :ets.tab2list(captured_events)

      docusign_events =
        Enum.filter(events, fn {event, _, _} ->
          List.first(event) == :docusign
        end)

      finch_events =
        Enum.filter(events, fn {event, _, _} ->
          List.first(event) == :finch
        end)

      # start and stop
      assert length(docusign_events) >= 2
      # request start and stop
      assert length(finch_events) >= 2

      # Verify finch_private metadata was passed through
      finch_stop =
        Enum.find(events, fn {event, _, _} ->
          event == [:finch, :request, :stop]
        end)

      if finch_stop do
        {_, _, finch_metadata} = finch_stop
        # The finch_private data should be in the request
        assert finch_metadata[:request] != nil
      end

      # Cleanup
      :telemetry.detach(handler_id)
      :ets.delete(captured_events)
    end
  end

  # Helper to rebuild connection with retry config
  defp rebuild_conn_with_retry(conn) do
    retry_options = Application.get_env(:docusign, :retry_options, [])

    updated_req =
      if retry_options[:enabled] == false do
        Req.merge(conn.req, retry: false)
      else
        max_retries = retry_options[:max_retries] || 3
        backoff_factor = retry_options[:backoff_factor] || 2
        max_delay = retry_options[:max_delay] || 30_000

        conn.req
        |> Req.merge(
          retry: :transient,
          max_retries: max_retries,
          retry_delay: fn attempt ->
            exponent = max(0, attempt)
            base_delay = Integer.pow(backoff_factor, exponent) * 1000
            jittered = base_delay + :rand.uniform(1000)
            min(jittered, max_delay)
          end
        )
      end

    %{conn | req: updated_req}
  end
end
