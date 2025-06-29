defmodule DocuSign.WebhookPlug do
  @moduledoc """
  Helper `Plug` to process webhook events and send them to a custom handler.

  Based on the excellent Stripe webhook plug:
  https://github.com/beam-community/stripity-stripe/blob/v3.1.1/lib/stripe/webhook_plug.ex

  ## Installation

  To handle webhook events, you must first configure your application's endpoint.
  Add the following to `endpoint.ex`, **before** `Plug.Parsers` is loaded.

  ```elixir
  plug DocuSign.WebhookPlug,
    at: "/webhook/docusign",
    handler: MyAppWeb.DocuSign.WebhookHandler,
    hmac_secret_key: fn -> Application.get_env(:myapp, :hmac_secret_key) end
  ```

  If you have not yet added a webhook to your DocuSign account, you can do so
  by visiting the 'Settings > Connect'. Use the route you configured in the
  endpoint above and copy the HMAC secret key into your app's configuration.

  ### Supported options

  - `at`: The URL path your application should listen for DocuSign webhooks on.
    Configure this to match whatever you set in the webhook.
  - `handler`: Custom event handler module that accepts `map()` payloads
    and processes them within your application. You must create this module.
  - `secret`: Webhook HMAC secret obtained from the DocuSign Connect dashboard.
    This can also be a function or a tuple for runtime configuration.

  ## Handling events

  You will need to create a custom event handler module to handle events.

  Your event handler module should implement the `DocuSign.Webhook.Handler`
  behavior, defining a `handle_webhook/1` function which takes a `map()`
  payload and returns either `{:ok, term}` or `:ok`. This will mark the event as
  successfully processed. Alternatively handler can signal an error by returning
  `:error` or `{:error, reason}` tuple, where reason is an atom or a string.
  HTTP status code 400 will be used for errors.

  Refer to https://developers.docusign.com/platform/webhooks/connect/json-sim-event-reference/
  for the possible payloads you may receive. Note that these payloads can vary
  based on your Connect configuration.

  ### Example

  ```elixir
  # lib/myapp_web/docusign_handler.ex

  defmodule MyAppWeb.DocuSignHandler do
    @behaviour DocuSign.Webhook.Handler

    @impl true
    def handle_webhook(%{"event" => "envelope-completed"} = event) do
      # TODO: handle the envelope-completed event
    end

    @impl true
    def handle_webhook(%{"event" => "envelope-discard"} = event) do
      # TODO: handle the "envelope-discard" event
    end

    # Return HTTP 200 for unhandled events
    @impl true
    def handle_webhook(_event), do: :ok
  end
  ```

  ## Configuration

  You can configure the HMAC secret key in your app's own config file.
  For example:

  ```elixir
  config :myapp,
    # [...]
    hmac_secret_key: "AB123_******"
  ```

  You may then include the secret in your endpoint:

  ```elixir
  plug DocuSign.WebhookPlug,
    at: "/webhook/docusign",
    handler: MyAppWeb.DocuSign.WebhookHandler,
    hmac_secret_key: Application.get_env(:myapp, :hmac_secret_key)
  ```

  ### Runtime configuration

  If you're loading config dynamically at runtime (eg with `runtime.exs`
  or an OTP app) you must pass a tuple or function as the secret.

  ```elixir
  # With a tuple
  plug DocuSign.WebhookPlug,
    at: "/webhook/docusign",
    handler: MyAppWeb.DocuSign.WebhookHandler,
    secret: {Application, :get_env, [:myapp, :hmac_secret_key]}

  # Or, with a function
  plug DocuSign.WebhookPlug,
    at: "/webhook/docusign",
    handler: MyAppWeb.DocuSign.WebhookHandler,
    secret: fn -> Application.get_env(:myapp, :hmac_secret_key) end
  ```

  ### HMAC secret key

  Only 1 HMAC secret key can be configured. It is assumed that to rotate
  the HMAC secret key:

  1. An additional HMAC secret key is added to the DocuSign Connect
    configuration.
  2. The HMAC secret key of the plug is updated to this new secret key.
  3. Finally the previous HMAC secret key is removed from the DocuSign Connect.

  ## HMAC signatures

  DocuSign can send up to 100 HMAC signatures, which would happen if you have
  configured 100 HMAC secret keys in your Connect dashboard. Although this is
  unlikely, the plug will check all of the signatures provided.
  """

  @behaviour Plug

  import Plug.Conn

  alias DocuSign.Webhook.Crypto
  alias Plug.Conn

  @impl true
  def init(opts) do
    path_info = String.split(opts[:at], "/", trim: true)

    opts
    |> Map.new()
    |> Map.put_new(:path_info, path_info)
  end

  # sobelow_skip ["XSS"]
  # `send_resp(conn, 400, reason)` is controlled by the handler module. It's not user input.
  @impl true
  def call(%Conn{method: "POST", path_info: path_info} = conn, %{
        handler: handler,
        hmac_secret_key: hmac_secret_key,
        path_info: path_info
      }) do
    secret = parse_secret!(hmac_secret_key)
    {:ok, payload, conn} = Conn.read_body(conn)

    with :ok <- verify_signatures(payload, secret, signatures(conn)),
        {:ok, %{} = event} <- parse_payload(payload),
        :ok <- handle_event!(handler, event) do
      halt(send_resp(conn, 200, "Webhook received."))
    else
      {:handle_error, reason} -> halt(send_resp(conn, 400, reason))
      _ -> halt(send_resp(conn, 400, "Bad request."))
    end
  end

  @impl true
  def call(%Conn{path_info: path_info} = conn, %{path_info: path_info}) do
    halt(send_resp(conn, 400, "Bad request."))
  end

  @impl true
  def call(conn, _), do: conn

  defp parse_secret!({m, f, a}), do: apply(m, f, a)
  defp parse_secret!(fun) when is_function(fun), do: fun.()
  defp parse_secret!(secret) when is_binary(secret), do: secret

  defp parse_secret!(secret) do
    raise RuntimeError, """
    The DocuSign HMAC secret is invalid. Expected a string, tuple, or function.
    Got: #{inspect(secret)}

    If you're setting the secret at runtime, you need to pass a tuple or function.
    For example:

    plug DocuSign.WebhookPlug,
      at: "/webhook/docusign",
      handler: MyAppWeb.DocuSignHandler,
      secret: {Application, :get_env, [:myapp, :docusign_hmac_secret]}
    """
  end

  defp signatures(conn) do
    Enum.flat_map(1..100, fn index -> get_req_header(conn, "x-docusign-signature-#{index}") end)
  end

  defp verify_signatures(payload, hmac_secret_key, signatures) do
    Enum.reduce_while(signatures, {:error, :no_matching_signatures}, fn signature, error_result ->
      if Crypto.verify_hmac(hmac_secret_key, payload, signature) do
        {:halt, :ok}
      else
        {:cont, error_result}
      end
    end)
  end

  defp parse_payload(payload) do
    case Jason.decode(payload) do
      {:ok, payload} -> {:ok, payload}
      {:error, _} -> {:error, "Invalid JSON payload."}
    end
  end

  defp handle_event!(handler, payload) do
    case handler.handle_webhook(payload) do
      :ok ->
        :ok

      {:ok, _} ->
        :ok

      {:error, reason} when is_binary(reason) ->
        {:handle_error, reason}

      {:error, reason} when is_atom(reason) ->
        {:handle_error, Atom.to_string(reason)}

      :error ->
        {:handle_error, ""}

      resp ->
        raise RuntimeError, """
        #{inspect(handler)}.handle_webhook/1 returned an invalid response. Expected {:ok, term}, :ok, {:error, reason} or :error
        Got: #{inspect(resp)}

        Event data: #{inspect(payload)}
        """
    end
  end
end
