defmodule DocuSign.WebhookPlugTest do
  use ExUnit.Case, async: true
  import Plug.Test
  import Plug.Conn

  alias DocuSign.Webhook.Crypto
  alias DocuSign.WebhookPlug

  @hmac256_key "sample-hmac-key"

  @webhook_event %{
    "event" => "envelope-completed",
    "apiVersion" => "v2.1",
    "uri" =>
      "/restapi/v2.1/accounts/b123a4e6-094f-43aa-b2d9-30076d0af3c7/envelopes/6b0cff6d-1def-40c3-9684-1587c8fcaa2c",
    "retryCount" => 0,
    "configurationId" => 123_456,
    "generatedDateTime" => "2024-02-13T14:34:42.2740396Z",
    "data" => %{
      "accountId" => "b123a4e6-094f-43aa-b2d9-30076d0af3c7",
      "userId" => "861d2a78-7e55-42a1-ba7f-7501cc1a0d28",
      "envelopeId" => "6b0cff6d-1def-40c3-9684-1587c8fcaa2c"
    }
  }

  @opts WebhookPlug.init(
          at: "/webhook/docusign",
          handler: __MODULE__.StubHandler,
          hmac_secret_key: "sample-hmac-key"
        )

  @opts_with_mfa_secret WebhookPlug.init(
                          at: "/webhook/docusign",
                          handler: __MODULE__.StubHandler,
                          hmac_secret_key: {__MODULE__, :docusign_hmac_secret, [:arg1, :arg2]}
                        )

  @opts_with_send_handler WebhookPlug.init(
                            at: "/webhook/docusign",
                            handler: __MODULE__.SendHandler,
                            hmac_secret_key: "sample-hmac-key"
                          )

  @opts_with_tuple_handler WebhookPlug.init(
                             at: "/webhook/docusign",
                             handler: __MODULE__.StubTupleHandler,
                             hmac_secret_key: "sample-hmac-key"
                           )

  @opts_with_error_atom_handler WebhookPlug.init(
                                  at: "/webhook/docusign",
                                  handler: __MODULE__.ErrorAtomHandler,
                                  hmac_secret_key: "sample-hmac-key"
                                )

  @opts_with_error_atom_reason_handler WebhookPlug.init(
                                         at: "/webhook/docusign",
                                         handler: __MODULE__.ErrorAtomReasonHandler,
                                         hmac_secret_key: "sample-hmac-key"
                                       )

  @opts_with_error_string_reason_handler WebhookPlug.init(
                                           at: "/webhook/docusign",
                                           handler: __MODULE__.ErrorStringReasonHandler,
                                           hmac_secret_key: "sample-hmac-key"
                                         )

  @opts_with_bad_handler WebhookPlug.init(
                           at: "/webhook/docusign",
                           handler: __MODULE__.BadHandler,
                           hmac_secret_key: "sample-hmac-key"
                         )

  defmodule StubHandler do
    @moduledoc """
    Webhook handler that always returns ok.
    """

    def handle_webhook(_payload), do: :ok
  end

  defmodule StubTupleHandler do
    @moduledoc """
    Webhook handler that always returns ok tuple.
    """

    def handle_webhook(_payload), do: {:ok, %{meta: true}}
  end

  defmodule SendHandler do
    @moduledoc """
    Webhook handler that sends event to current process.
    """

    def handle_webhook(payload) do
      send(self(), {:webhook_event, payload})
      :ok
    end
  end

  defmodule ErrorAtomHandler do
    @moduledoc """
    Webhook handler that always returns :error.
    """

    def handle_webhook(_payload), do: :error
  end

  defmodule ErrorAtomReasonHandler do
    @moduledoc """
    Webhook handler that always returns `{:error, :timeout}`.
    """

    def handle_webhook(_payload), do: {:error, :timeout}
  end

  defmodule ErrorStringReasonHandler do
    @moduledoc """
    Webhook handler that always returns `{:error, "Unable to process webhook right now."}`.
    """

    def handle_webhook(_payload), do: {:error, "Unable to process webhook right now."}
  end

  defmodule BadHandler do
    @moduledoc """
    Handler that does not implement handler behaviour.
    """

    def handle_webhook(_payload), do: :timeout
  end

  describe "WebhookPlug" do
    test "passes webhook event to handler" do
      conn = build_request(@webhook_event, @hmac256_key)
      WebhookPlug.call(conn, @opts_with_send_handler)
      assert_received {:webhook_event, @webhook_event}
      assert {200, _, "Webhook received."} = sent_resp(conn)
    end

    test "returns 200 if handler returns ok tuple" do
      conn = build_request(@webhook_event, @hmac256_key)
      conn = WebhookPlug.call(conn, @opts_with_tuple_handler)
      assert {200, _, "Webhook received."} = sent_resp(conn)
    end

    test "returns 400 if handler returns :error" do
      conn = build_request(@webhook_event, @hmac256_key)
      conn = WebhookPlug.call(conn, @opts_with_error_atom_handler)
      assert {400, _, ""} = sent_resp(conn)
    end

    test "returns 400 with reason if handler returns error with atom reason" do
      conn = build_request(@webhook_event, @hmac256_key)
      conn = WebhookPlug.call(conn, @opts_with_error_atom_reason_handler)
      assert {400, _, "timeout"} = sent_resp(conn)
    end

    test "returns 400 with reason if handler returns error with string reason" do
      conn = build_request(@webhook_event, @hmac256_key)
      conn = WebhookPlug.call(conn, @opts_with_error_string_reason_handler)
      assert {400, _, "Unable to process webhook right now."} = sent_resp(conn)
    end

    test "crash hard if handler fails" do
      conn = build_request(@webhook_event, @hmac256_key)

      expected_exception_message = """
      DocuSign.WebhookPlugTest.BadHandler.handle_webhook/1 returned an invalid response. Expected {:ok, term}, :ok, {:error, reason} or :error
      Got: :timeout

      Event data: #{inspect(@webhook_event)}
      """

      assert_raise RuntimeError, expected_exception_message, fn ->
        WebhookPlug.call(conn, @opts_with_bad_handler)
      end
    end

    test "accepts valid signature" do
      conn = build_request(@webhook_event, @hmac256_key)
      conn = WebhookPlug.call(conn, @opts)
      assert {200, _, "Webhook received."} = sent_resp(conn)
    end

    test "accepts multiple signatures if one signature is valid" do
      conn = build_request(@webhook_event, ["different-key", @hmac256_key, "another-key"])
      conn = WebhookPlug.call(conn, @opts)
      assert {200, _, "Webhook received."} = sent_resp(conn)
    end

    test "rejects invalid signature" do
      conn = build_request(@webhook_event, "not-the-right-key")
      conn = WebhookPlug.call(conn, @opts)
      assert {400, _, "Bad request."} = sent_resp(conn)
    end

    test "rejects request with multiple signatures that are all invalid" do
      conn = build_request(@webhook_event, ["not-the-right-key", "still-not-right"])
      conn = WebhookPlug.call(conn, @opts)
      assert {400, _, "Bad request."} = sent_resp(conn)
    end

    test "rejects request without signature" do
      conn = build_request(@webhook_event, [])
      conn = WebhookPlug.call(conn, @opts)
      assert {400, _, "Bad request."} = sent_resp(conn)
    end

    test "rejects non-JSON payloads" do
      conn = build_request("<h1>not JSON for sure</h1>", @hmac256_key)
      conn = WebhookPlug.call(conn, @opts)
      assert {400, _, "Bad request."} = sent_resp(conn)
    end

    test "ignores requests for other paths" do
      conn = conn(:post, "/home")
      conn = WebhookPlug.call(conn, @opts)
      refute conn.status
    end

    test "rejects non-POST requests" do
      payload = Jason.encode!(@webhook_event)

      conn =
        conn(:get, "/webhook/docusign", payload)
        |> put_req_header("content-type", "application/json")
        |> sign_request(payload, [@hmac256_key])

      conn = WebhookPlug.call(conn, @opts)
      assert {400, _, "Bad request."} = sent_resp(conn)
    end

    test "accepts secret from mfa tuple" do
      conn = build_request(@webhook_event, @hmac256_key)
      conn = WebhookPlug.call(conn, @opts_with_mfa_secret)
      assert {200, _, "Webhook received."} = sent_resp(conn)
    end

    test "accepts secret from function" do
      conn = build_request(@webhook_event, @hmac256_key)

      opts =
        WebhookPlug.init(
          at: "/webhook/docusign",
          handler: __MODULE__.StubHandler,
          hmac_secret_key: fn -> @hmac256_key end
        )

      conn = WebhookPlug.call(conn, opts)
      assert {200, _, "Webhook received."} = sent_resp(conn)
    end

    test "raises on invalid HMAC secret" do
      conn = build_request(@webhook_event, @hmac256_key)

      opts =
        WebhookPlug.init(
          at: "/webhook/docusign",
          handler: __MODULE__.StubHandler,
          hmac_secret_key: 12_345
        )

      expected_exception_message = """
      The DocuSign HMAC secret is invalid. Expected a string, tuple, or function.
      Got: 12345

      If you're setting the secret at runtime, you need to pass a tuple or function.
      For example:

      plug DocuSign.WebhookPlug,
        at: "/webhook/docusign",
        handler: MyAppWeb.DocuSignHandler,
        secret: {Application, :get_env, [:myapp, :docusign_hmac_secret]}
      """

      assert_raise RuntimeError, expected_exception_message, fn ->
        WebhookPlug.call(conn, opts)
      end
    end
  end

  defp build_request(payload, hmac256_key_or_keys) when is_map(payload) do
    build_request(Jason.encode!(payload), hmac256_key_or_keys)
  end

  defp build_request(payload, hmac256_key_or_keys) when is_binary(payload) do
    conn(:post, "/webhook/docusign", payload)
    |> put_req_header("content-type", "application/json")
    |> sign_request(payload, List.wrap(hmac256_key_or_keys))
  end

  defp sign_request(conn, payload, hmac256_key_or_keys) do
    for {key, index} <- Enum.with_index(hmac256_key_or_keys), reduce: conn do
      conn ->
        one_based_index = index + 1

        put_req_header(
          conn,
          "x-docusign-signature-#{one_based_index}",
          Crypto.sign(payload, key)
        )
    end
  end

  # See @opts_with_mfa_secret
  def docusign_hmac_secret(:arg1, :arg2) do
    @hmac256_key
  end
end
