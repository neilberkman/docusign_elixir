defmodule DocuSign.ConnectionTest do
  use ExUnit.Case, async: false

  alias DocuSign.Connection

  import DocuSign.EnvHelper
  import DocuSign.ProcessHelper

  describe "creating a connection" do
    setup do
      {:ok, pid} = DocuSign.APIClient.start_link()
      on_exit(fn -> assert_down(pid) end)
    end

    test "returns connection using default user ID" do
      connection = Connection.new()

      assert connection.client.ref.user_id == ":user-id:"
    end
  end

  describe "requesting with a configured timeout" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "request without timeout returns payload", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, "")
      end)

      result = do_request(bypass)

      refute result == :timeout
    end

    test "request with timeout less than 2s returns :timeout", %{bypass: bypass} do
      # By default, Mint times out after 2s
      put_env(:docusign, :timeout, 500)

      Bypass.expect_once(bypass, fn conn ->
        Process.sleep(1_000)
        Plug.Conn.resp(conn, 200, "")
      end)

      result = do_request(bypass)

      assert result == :timeout

      # Force bypass expectations to pass to prevent exit :shutdown error
      Bypass.pass(bypass)
    end
  end

  defp do_request(bypass) do
    conn = %Connection{
      client: %{token: %OAuth2.AccessToken{}},
      app_account: %DocuSign.User.AppAccount{base_uri: "http://localhost:#{bypass.port}"}
    }

    opts = [method: :GET, url: "/endpoint"]

    Connection.request(conn, opts)
  end
end
