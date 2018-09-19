defmodule DocuSign.OAuthTest do
  use ExUnit.Case, async: true

  alias DocuSign.OAuth
  alias OAuth2.{Client, AccessToken}

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "get_token!", %{bypass: bypass} do
    token = ~s({
      "access_token": "ISSUED_ACCESS_TOKEN",
      "token_type": "Bearer",
      "refresh_token": "ISSUED_REFRESH_TOKEN",
      "expires_in": 28800})
    Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
      Plug.Conn.resp(conn, 200, token)
    end)

    client = OAuth.client(site: "http://localhost:#{bypass.port}")
    |> OAuth.get_token!()
    assert %OAuth2.AccessToken{
      access_token: "ISSUED_ACCESS_TOKEN",
      other_params: %{},
      refresh_token: "ISSUED_REFRESH_TOKEN",
      token_type: "Bearer"
    } = client.token
  end

  test "token_expired?" do
    token = %AccessToken{expires_at: :os.system_time(:seconds) - 30}
    assert OAuth.token_expired?(nil)
    assert OAuth.token_expired?(token)
    assert OAuth.token_expired?(%Client{token: token})
  end

  test "refresh_token!" do
  end
end
