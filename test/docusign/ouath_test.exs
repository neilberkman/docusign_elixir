defmodule DocuSign.OAuthTest do
  use ExUnit.Case
  alias DocuSign.OAuth
  alias OAuth2.{Client, AccessToken}

  test "token_expired?" do
    token = %AccessToken{expires_at: :os.system_time(:seconds) - 30}
    assert OAuth.token_expired?(nil)
    assert OAuth.token_expired?(token)
    assert OAuth.token_expired?(%Client{token: token})
  end
end
