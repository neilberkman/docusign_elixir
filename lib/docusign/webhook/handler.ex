defmodule DocuSign.Webhook.Handler do
  @moduledoc """
  Webhook handler behaviour.
  """

  @type error_reason :: binary() | atom()

  @callback handle_webhook(map()) :: :ok | {:ok, any()} | :error | {:error, error_reason()}
end
