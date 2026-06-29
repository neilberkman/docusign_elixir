defmodule DocuSign.TestHTTPServer do
  @moduledoc false

  use GenServer

  alias Elixir.Plug.Conn

  defstruct [:pid, :server_pid, :port]

  def open(opts \\ []) do
    {:ok, pid} = GenServer.start(__MODULE__, opts)
    %{server_pid: server_pid, port: port} = GenServer.call(pid, :info)

    server = %__MODULE__{pid: pid, server_pid: server_pid, port: port}
    ref = make_ref()

    ExUnit.Callbacks.on_exit({__MODULE__, ref}, fn ->
      try do
        verify!(server)
      after
        stop(server)
      end
    end)

    server
  end

  def expect_once(server, responder) when is_function(responder, 1) do
    put_expectation(server, :any, :once, responder)
  end

  def expect_once(server, method, path, responder) when is_function(responder, 1) do
    put_expectation(server, route(method, path), :once, responder)
  end

  def expect(server, responder) when is_function(responder, 1) do
    put_expectation(server, :any, :many, responder)
  end

  def expect(server, method, path, responder) when is_function(responder, 1) do
    put_expectation(server, route(method, path), :many, responder)
  end

  def stub(server, method, path, responder) when is_function(responder, 1) do
    put_expectation(server, route(method, path), :stub, responder)
  end

  def down(server) do
    GenServer.call(server.pid, :down)
  end

  def pass(server) do
    GenServer.call(server.pid, :pass)
  end

  def verify!(server) do
    if Process.alive?(server.pid) do
      case GenServer.call(server.pid, :verify) do
        :ok ->
          :ok

        {:error, failures} ->
          raise ExUnit.AssertionError, message: render_failures(failures)
      end
    end
  end

  def stop(server) do
    if Process.alive?(server.pid) do
      GenServer.stop(server.pid, :normal)
    end
  catch
    :exit, _ -> :ok
  end

  @impl true
  def init(_opts) do
    Process.flag(:trap_exit, true)

    {:ok, server_pid} =
      Bandit.start_link(
        plug: {__MODULE__.Plug, self()},
        port: 0,
        scheme: :http,
        startup_log: false
      )

    {:ok, {_host, port}} = ThousandIsland.listener_info(server_pid)

    {:ok,
     %{
       server_pid: server_pid,
       port: port,
       expectations: [],
       handler_errors: [],
       unexpected_requests: [],
       pass?: false
     }}
  end

  @impl true
  def handle_call(:info, _from, state) do
    {:reply, %{server_pid: state.server_pid, port: state.port}, state}
  end

  def handle_call({:put_expectation, expectation}, _from, state) do
    {:reply, :ok, %{state | expectations: state.expectations ++ [expectation]}}
  end

  def handle_call({:request, method, path}, _from, state) do
    request = %{method: method, path: path}

    case pop_responder(state.expectations, request) do
      {:ok, responder, expectations} ->
        {:reply, {:ok, responder}, %{state | expectations: expectations}}

      :error ->
        state = %{state | unexpected_requests: state.unexpected_requests ++ [request]}
        {:reply, {:error, :unexpected_request}, state}
    end
  end

  def handle_call(:down, _from, state) do
    if state.server_pid && Process.alive?(state.server_pid) do
      Process.exit(state.server_pid, :shutdown)
    end

    {:reply, :ok, %{state | server_pid: nil}}
  end

  def handle_call(:pass, _from, state) do
    {:reply, :ok, %{state | pass?: true}}
  end

  def handle_call(:verify, _from, state) do
    failures =
      state.handler_errors ++
        if state.pass? do
          []
        else
          pending_expectations(state) ++ state.unexpected_requests
        end

    reply =
      if failures == [] do
        :ok
      else
        {:error, failures}
      end

    {:reply, reply, state}
  end

  @impl true
  def handle_cast({:handler_error, error}, state) do
    {:noreply, %{state | handler_errors: state.handler_errors ++ [error]}}
  end

  @impl true
  def handle_info({:EXIT, pid, _reason}, %{server_pid: pid} = state) do
    {:noreply, %{state | server_pid: nil}}
  end

  def handle_info({:EXIT, _pid, _reason}, state), do: {:noreply, state}

  @impl true
  def terminate(_reason, state) do
    if state.server_pid && Process.alive?(state.server_pid) do
      Process.exit(state.server_pid, :shutdown)
    end

    :ok
  end

  defp put_expectation(server, route, mode, responder) do
    expectation = %{
      route: route,
      mode: mode,
      responder: responder,
      calls: 0
    }

    GenServer.call(server.pid, {:put_expectation, expectation})
  end

  defp route(method, path), do: {normalize_method(method), path}

  defp normalize_method(method) when is_binary(method), do: String.upcase(method)
  defp normalize_method(method) when is_atom(method), do: method |> Atom.to_string() |> String.upcase()

  defp pop_responder(expectations, request) do
    case Enum.find_index(expectations, &available_match?(&1, request)) do
      nil ->
        :error

      index ->
        expectation = Enum.at(expectations, index)
        updated = %{expectation | calls: expectation.calls + 1}
        expectations = List.replace_at(expectations, index, updated)
        {:ok, expectation.responder, expectations}
    end
  end

  defp available_match?(%{mode: :once, calls: calls}, _request) when calls >= 1, do: false

  defp available_match?(expectation, request), do: route_matches?(expectation.route, request)

  defp route_matches?(:any, _request), do: true

  defp route_matches?({expected_method, expected_path}, %{method: method, path: path}) do
    expected_method == method && expected_path == path
  end

  defp route_matches?(_route, _request), do: false

  defp pending_expectations(%{expectations: expectations}) do
    Enum.filter(expectations, fn
      %{mode: :once, calls: 1} -> false
      %{mode: :once} -> true
      %{mode: :many, calls: calls} -> calls < 1
      %{mode: :stub} -> false
    end)
  end

  defp render_failures(failures) do
    failures
    |> Enum.map_join("\n", &render_failure/1)
  end

  defp render_failure(%{route: route, mode: mode, calls: calls}) do
    "Expected #{mode} request for #{format_route(route)}, received #{calls}."
  end

  defp render_failure(%{method: method, path: path}) do
    "Unexpected #{method} request to #{path}."
  end

  defp render_failure({:handler_error, kind, reason, stacktrace}) do
    Exception.format(kind, reason, stacktrace)
  end

  defp format_route(:any), do: "any route"
  defp format_route({method, path}), do: "#{method} #{path}"

  defmodule Plug do
    @moduledoc false

    def init(owner), do: owner

    def call(conn, owner) do
      case GenServer.call(owner, {:request, conn.method, conn.request_path}) do
        {:ok, responder} ->
          run_responder(conn, owner, responder)

        {:error, :unexpected_request} ->
          Conn.resp(conn, 500, "Unexpected request: #{conn.method} #{conn.request_path}")
      end
    end

    defp run_responder(conn, owner, responder) do
      responder.(conn)
    rescue
      exception ->
        stacktrace = __STACKTRACE__
        GenServer.cast(owner, {:handler_error, {:handler_error, :error, exception, stacktrace}})
        reraise exception, stacktrace
    catch
      kind, reason ->
        stacktrace = __STACKTRACE__
        GenServer.cast(owner, {:handler_error, {:handler_error, kind, reason, stacktrace}})
        :erlang.raise(kind, reason, stacktrace)
    end
  end
end
