defmodule DocuSign.Webhook.Crypto do
  @moduledoc """
  Crypto functions for DocuSign HMAC signature validation.
  """

  @type hmac256_key :: binary()
  @type request_body :: binary()
  @type signature :: binary()

  @doc """
  Verify HMAC-SHA256 signature.
  """
  @spec verify_hmac(hmac256_key(), request_body(), signature()) :: boolean()
  def verify_hmac(hmac256_key, request_body, signature) do
    hmac = :crypto.mac(:hmac, :sha256, hmac256_key, request_body)
    encoded_hmac = Base.encode64(hmac)

    # `:crypto.hash_equals/2` will raise an error if the signatures are not the
    # same length. We avoid this by checking the length first.
    if String.length(encoded_hmac) != String.length(signature) do
      false
    else
      :crypto.hash_equals(encoded_hmac, signature)
    end
  end

  @doc """
  Sign payload with HMAC-SHA256 key.
  """
  @spec sign(request_body(), hmac256_key()) :: signature()
  def sign(payload, hmac256_key) when is_binary(payload) do
    hmac = :crypto.mac(:hmac, :sha256, hmac256_key, payload)
    Base.encode64(hmac)
  end
end
