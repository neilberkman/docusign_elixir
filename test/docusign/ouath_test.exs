defmodule DocuSign.OAuthTest do
  use ExUnit.Case, async: true

  alias DocuSign.OAuth
  alias OAuth2.{AccessToken, Client}
  alias Plug.Conn

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  @token ~s({
    "access_token": "ISSUED_ACCESS_TOKEN",
    "token_type": "Bearer",
    "refresh_token": "ISSUED_REFRESH_TOKEN",
    "expires_in": 28800})

  test "get_token!", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
      Conn.resp(conn, 200, @token)
    end)

    client = OAuth.get_token!(OAuth.client(site: "http://localhost:#{bypass.port}"))

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
           } = OAuth.get_token(OAuth.client(site: "http://localhost"), [], [])
  end

  test "refresh_token!", %{bypass: bypass} do
    now = :os.system_time(:seconds)

    client =
      OAuth.client(
        site: "http://localhost:#{bypass.port}",
        token: %AccessToken{
          expires_at: now + 3600,
          access_token: "TEST_TOKEN"
        }
      )

    Bypass.expect(bypass, "POST", "/oauth/token", fn conn ->
      Conn.resp(conn, 200, @token)
    end)

    assert %AccessToken{access_token: "TEST_TOKEN"} = OAuth.refresh_token!(client).token

    assert %AccessToken{access_token: "ISSUED_ACCESS_TOKEN"} =
             OAuth.refresh_token!(client, true).token

    expired_client = %Client{client | token: %AccessToken{expires_at: now - 3600}}

    assert %AccessToken{access_token: "ISSUED_ACCESS_TOKEN"} =
             OAuth.refresh_token!(expired_client).token
  end

  test "interval_refresh_token" do
    now = :os.system_time(:seconds)
    token = %AccessToken{expires_at: now + 3600}
    client = %Client{token: token}
    assert OAuth.interval_refresh_token(client) == 3590
  end
end
