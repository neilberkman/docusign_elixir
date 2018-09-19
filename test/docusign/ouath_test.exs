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

    client =
      OAuth.client(site: "http://localhost:#{bypass.port}")
      |> OAuth.get_token!()

    assert %OAuth2.AccessToken{
             access_token: "ISSUED_ACCESS_TOKEN",
             other_params: %{},
             refresh_token: "ISSUED_REFRESH_TOKEN",
             token_type: "Bearer"
           } = client.token
  end

  test "token_expired?" do
    expired_token = %AccessToken{expires_at: :os.system_time(:seconds) - 30}
    actual_token = %AccessToken{expires_at: :os.system_time(:seconds) + 3600}
    assert OAuth.token_expired?(nil)
    assert OAuth.token_expired?(expired_token)
    assert OAuth.token_expired?(%Client{token: expired_token})

    refute OAuth.token_expired?(actual_token)
    refute OAuth.token_expired?(%Client{token: actual_token})
  end

  test "refresh_token!" do
  end

  test "create new api client" do
    assert %Client{
             request_opts: [],
             site: "http://localhost",
             strategy: DocuSign.OAuth,
             token: nil,
             token_method: :post,
             token_url: "/oauth/token"
           } = OAuth.client(site: "http://localhost")
  end

  test "get_token" do
    assert %Client{
             params: %{
               "assertion" => _,
               "grant_type" => "urn:ietf:params:oauth:grant-type:jwt-bearer"
             }
           } =
             OAuth.client(site: "http://localhost")
             |> OAuth.get_token([], [])
  end
end
