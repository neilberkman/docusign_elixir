defmodule DocuSign.UserTest do
  use ExUnit.Case, async: true

  @user_info ~s({
    "accounts": [
      {
        "account_id": "61ac4bd1-c83c-4aa6-8654-d3b44a252f42",
        "account_name": "Tandem Equity LLC",
        "base_uri": "https://demo.docusign.net",
        "is_default": true
      }
    ],
    "created": "2018-09-07T23:49:34.163",
    "email": "neil@test.com",
    "family_name": "Test",
    "given_name": "Neil",
    "name": "Neil Test1",
    "sub": "84a39dd2-b972-48b2-929a-cf743466a4d5"
      })

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "info", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/oauth/userinfo", fn conn ->
      Plug.Conn.resp(conn, 200, @user_info)
    end)

    client = DocuSign.OAuth.client(site: "http://localhost:#{bypass.port}")

    assert %DocuSign.User{
             created: "2018-09-07T23:49:34.163",
             email: "neil@test.com",
             family_name: "Test",
             given_name: "Neil",
             name: "Neil Test1",
             sub: "84a39dd2-b972-48b2-929a-cf743466a4d5"
           } = DocuSign.User.info(client)
  end
end
