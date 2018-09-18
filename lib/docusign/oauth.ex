defmodule DocuSign.OAuth do
  @private_key Application.get_env(:docusign, :private_key)
  @token_expires_in Application.get_env(:docusign, :token_expires_in)
  @hostname Application.get_env(:docusign, :hostname)

  alias DocuSign.Request

  def token_invalid?(%AuthToken{token: nil} = _), do: true
  def token_invalid?(auth_token), do: token_expired?(auth_token)

  def refreshed_auth_token(
        %{client_id: client_id, user_id: user_id},
        expires_in \\ @token_expires_in
      ) do
    now_and_later = time_span(expires_in)

    claims(now_and_later, client_id, user_id)
    |> signed_token
    |> fetched_auth_token(now_and_later)
  end

  ###
  # Private functions
  ##

  defp claims({now, expiration}, client_id, user_id) do
    %{
      iss: client_id,
      sub: user_id,
      aud: @hostname,
      iat: now,
      exp: expiration,
      scope: "signature"
    }
  end

  defp now_unix, do: DateTime.utc_now() |> DateTime.to_unix()

  defp time_span(seconds_in_future) do
    now = now_unix()
    {now, now + seconds_in_future}
  end

  defp signed_token(claims) do
    key = JOSE.JWK.from_pem_file(@private_key)

    claims
    |> Joken.token()
    |> Joken.sign(Joken.rs256(key))
    |> Joken.get_compact()
  end

  defp fetched_auth_token(assertion, {_, expiration}) do
    Request.post_form(
      "oauth/token",
      [
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion: assertion
      ],
      nil
    )
    |> extracted_auth_token(expiration)
  end

  defp extracted_auth_token({:ok, %HTTPoison.Response{body: body}}, expiration) do
    data = Poison.decode!(body)
    token = data["token_type"] <> " " <> data["access_token"]

    %AuthToken{token: token, expiration: expiration}
  end

  defp extracted_auth_token({:error, %HTTPoison.Response{status_code: status_code}}, _) do
    raise "Authentication failed with status code #{status_code}"
  end

  defp token_expired?(%AuthToken{} = expiration), do: now_unix() >= expiration
end
