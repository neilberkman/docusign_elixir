defmodule DocuSign.TelemetryTest do
  use ExUnit.Case, async: false

  alias DocuSign.Telemetry

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

    # Create a test connection
    req =
      Req.new(
        base_url: "http://localhost:#{server.port}",
        headers: [
          {"authorization", "Bearer test-token"},
          {"content-type", "application/json"}
        ]
      )

    conn = %DocuSign.Connection{
      app_account: %{
        account_id: "test-account-123",
        base_uri: "http://localhost:#{server.port}"
      },
      req: req
    }

    {:ok, server: server, conn: conn}
  end

  describe "telemetry events" do
    @tag capture_log: true
    test "emits api start and stop events for successful requests", %{server: server, conn: conn} do
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
      DocuSign.TestHTTPServer.expect_once(server, "GET", "/v2.1/accounts/test-account-123/envelopes", fn conn ->
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

    @tag capture_log: true
    test "emits api exception event for connection failures", %{server: server, conn: conn} do
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

      # Stop server to force connection error
      DocuSign.TestHTTPServer.down(server)

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

    @tag capture_log: true
    test "emits rate limit event when hitting 429", %{server: server} do
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

      on_exit(fn -> :telemetry.detach(handler_id) end)

      Application.put_env(:docusign, :retry_options,
        max_retries: 1,
        backoff_factor: 1,
        max_delay: 100
      )

      conn = build_connection(server, "test-account-123")
      {:ok, agent} = Agent.start_link(fn -> 0 end)

      DocuSign.TestHTTPServer.expect(server, "GET", "/test", fn conn ->
        case Agent.get_and_update(agent, fn c -> {c, c + 1} end) do
          0 ->
            conn
            |> Plug.Conn.put_resp_header("retry-after", "1")
            |> Plug.Conn.resp(429, "Rate Limited")

          1 ->
            Plug.Conn.resp(conn, 200, ~s({"success": true}))
        end
      end)

      assert {:ok, _response} =
               DocuSign.Connection.request(conn,
                 method: :get,
                 url: "/test",
                 telemetry_metadata: %{operation: "test_operation"}
               )

      assert [{[:docusign, :rate_limit, :hit], %{retry_after: 1}, metadata}] =
               :ets.tab2list(captured_events)

      assert metadata[:operation] == "test_operation"
      assert metadata[:account_id] == "test-account-123"
      :ets.delete(captured_events)
    end

    @tag capture_log: true
    test "automatically extracts operation name from path", %{server: server, conn: conn} do
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
      DocuSign.TestHTTPServer.expect_once(server, "POST", "/v2.1/accounts/123/envelopes", fn conn ->
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

  defp build_connection(server, account_id) do
    {:ok, conn} =
      DocuSign.Connection.from_oauth_client(
        OAuth2.Client.new(token: "test-token"),
        account_id: account_id,
        base_uri: "http://localhost:#{server.port}"
      )

    conn
  end

  describe "telemetry span" do
    @tag capture_log: true
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

    @tag capture_log: true
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
    @tag capture_log: true
    test "finch events are emitted alongside docusign events", %{server: server, conn: conn} do
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
      DocuSign.TestHTTPServer.expect_once(server, "GET", "/test", fn conn ->
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
end
