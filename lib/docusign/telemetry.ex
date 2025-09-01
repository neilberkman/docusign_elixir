defmodule DocuSign.Telemetry do
  @moduledoc """
  Telemetry integration for DocuSign API operations.

  This module provides telemetry events for monitoring and observability of DocuSign API interactions.
  It builds on top of the underlying Finch telemetry events to provide DocuSign-specific metrics.

  ## Events

  The following telemetry events are emitted:

  ### API Operation Events

  * `[:docusign, :api, :start]` - Executed before making an API call

    Measurements:
    * `:system_time` - System time when the operation started

    Metadata:
    * `:operation` - The API operation being performed (e.g., "envelopes_post_envelopes")
    * `:account_id` - The DocuSign account ID
    * `:method` - HTTP method (`:get`, `:post`, etc.)
    * `:path` - API path being called
    * `:connection` - The DocuSign.Connection struct

  * `[:docusign, :api, :stop]` - Executed after a successful API call

    Measurements:
    * `:duration` - Time taken for the operation in native units

    Metadata:
    * `:operation` - The API operation performed
    * `:account_id` - The DocuSign account ID
    * `:method` - HTTP method
    * `:path` - API path
    * `:status` - HTTP response status code
    * `:connection` - The DocuSign.Connection struct

  * `[:docusign, :api, :exception]` - Executed when an API call fails

    Measurements:
    * `:duration` - Time taken before failure in native units

    Metadata:
    * `:operation` - The API operation attempted
    * `:account_id` - The DocuSign account ID (if available)
    * `:method` - HTTP method
    * `:path` - API path
    * `:kind` - The kind of exception (`:throw`, `:error`, `:exit`)
    * `:reason` - The exception reason/error
    * `:stacktrace` - The stacktrace
    * `:connection` - The DocuSign.Connection struct

  ### Authentication Events

  * `[:docusign, :auth, :token_refresh]` - Executed when refreshing an OAuth token

    Measurements:
    * `:duration` - Time taken to refresh the token

    Metadata:
    * `:success` - Boolean indicating if refresh succeeded
    * `:user_id` - User ID for JWT auth (if applicable)

  ### Rate Limiting Events

  * `[:docusign, :rate_limit, :hit]` - Executed when hitting a rate limit

    Measurements:
    * `:retry_after` - Seconds to wait before retry (from header)

    Metadata:
    * `:operation` - The API operation that hit the limit
    * `:account_id` - The DocuSign account ID

  ## Usage Examples

  ### Basic Handler

      defmodule MyApp.DocuSignTelemetry do
        require Logger

        def attach do
          :telemetry.attach_many(
            "docusign-handler",
            [
              [:docusign, :api, :start],
              [:docusign, :api, :stop],
              [:docusign, :api, :exception]
            ],
            &handle_event/4,
            nil
          )
        end

        def handle_event([:docusign, :api, :stop], measurements, metadata, _config) do
          Logger.info(
            "DocuSign API call completed",
            operation: metadata.operation,
            duration_ms: System.convert_time_unit(measurements.duration, :native, :millisecond),
            status: metadata.status
          )
        end

        def handle_event([:docusign, :api, :exception], _measurements, metadata, _config) do
          Logger.error(
            "DocuSign API call failed",
            operation: metadata.operation,
            error: metadata.reason
          )
        end

        def handle_event(_event, _measurements, _metadata, _config), do: :ok
      end

  ### Integration with Telemetry.Metrics

      defmodule MyApp.Telemetry do
        import Telemetry.Metrics

        def metrics do
          [
            # API performance metrics
            summary("docusign.api.duration",
              unit: {:native, :millisecond},
              tags: [:operation, :status]
            ),

            # Request rate
            counter("docusign.api.count",
              tags: [:operation, :status]
            ),

            # Error rate
            counter("docusign.api.exception.count",
              tags: [:operation]
            ),

            # Rate limiting
            counter("docusign.rate_limit.hit.count",
              tags: [:operation]
            )
          ]
        end
      end

  ## Finch Telemetry Events

  Since DocuSign uses Req/Finch under the hood, you also have access to lower-level HTTP telemetry:

  * `[:finch, :request, :start]` - HTTP request started
  * `[:finch, :request, :stop]` - HTTP request completed
  * `[:finch, :queue, :start]` - Request queued for connection pool
  * `[:finch, :queue, :stop]` - Request dequeued
  * `[:finch, :connect, :start]` - Connection establishment started
  * `[:finch, :connect, :stop]` - Connection established

  See `Finch.Telemetry` for complete documentation of these events.
  """

  @doc """
  Execute a telemetry event for an API operation start.
  """
  def execute_api_start(operation, metadata) do
    measurements = %{system_time: System.system_time()}

    :telemetry.execute(
      [:docusign, :api, :start],
      measurements,
      Map.put(metadata, :operation, operation)
    )
  end

  @doc """
  Execute a telemetry event for an API operation stop.
  """
  def execute_api_stop(operation, start_time, metadata) do
    measurements = %{
      duration: System.monotonic_time() - start_time
    }

    :telemetry.execute(
      [:docusign, :api, :stop],
      measurements,
      Map.put(metadata, :operation, operation)
    )
  end

  @doc """
  Execute a telemetry event for an API operation exception.
  """
  def execute_api_exception(operation, start_time, kind, reason, stacktrace, metadata) do
    measurements = %{
      duration: System.monotonic_time() - start_time
    }

    :telemetry.execute(
      [:docusign, :api, :exception],
      measurements,
      Map.merge(metadata, %{
        kind: kind,
        operation: operation,
        reason: reason,
        stacktrace: stacktrace
      })
    )
  end

  @doc """
  Execute a telemetry event for rate limiting.
  """
  def execute_rate_limit(operation, retry_after, metadata) do
    measurements = %{retry_after: retry_after}

    :telemetry.execute(
      [:docusign, :rate_limit, :hit],
      measurements,
      Map.put(metadata, :operation, operation)
    )
  end

  @doc """
  Execute a telemetry event for token refresh.
  """
  def execute_token_refresh(duration, success, metadata) do
    measurements = %{duration: duration}

    :telemetry.execute(
      [:docusign, :auth, :token_refresh],
      measurements,
      Map.put(metadata, :success, success)
    )
  end

  @doc """
  Wraps a function call with telemetry events.

  This is a convenience function for wrapping any operation with start/stop/exception events.

  ## Examples

      Telemetry.span([:docusign, :custom, :operation], %{account_id: "123"}, fn ->
        # Your operation here
        {:ok, result}
      end)
  """
  def span(event_prefix, metadata, fun) do
    start_metadata = Map.put(metadata, :system_time, System.system_time())
    start_time = System.monotonic_time()

    :telemetry.execute(
      event_prefix ++ [:start],
      %{system_time: System.system_time()},
      start_metadata
    )

    try do
      result = fun.()

      stop_measurements = %{duration: System.monotonic_time() - start_time}
      stop_metadata = Map.put(metadata, :result, result)
      :telemetry.execute(event_prefix ++ [:stop], stop_measurements, stop_metadata)

      result
    rescue
      exception ->
        exception_measurements = %{duration: System.monotonic_time() - start_time}

        exception_metadata =
          Map.merge(metadata, %{
            kind: :error,
            reason: exception,
            stacktrace: __STACKTRACE__
          })

        :telemetry.execute(
          event_prefix ++ [:exception],
          exception_measurements,
          exception_metadata
        )

        reraise exception, __STACKTRACE__
    end
  end
end
