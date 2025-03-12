defmodule DocuSign.OAuth.ImplTest do
  use ExUnit.Case, async: true

  alias DocuSign.OAuth
  alias OAuth2.{AccessToken, Client}
  alias Plug.Conn

  import ExUnit.CaptureLog

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  setup do
    # Some tests will override the application environment so reset it between tests.
    Application.delete_env(:docusign, :token_signer)
    Application.delete_env(:docusign, :private_key_file)
    Application.delete_env(:docusign, :private_key_contents)
    # Use private_key_file in v2.0.0+ (private_key was removed)
    Application.put_env(:docusign, :private_key_file, "test/support/test_key")
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

    client = OAuth.Impl.get_token!(OAuth.Impl.client(site: "http://localhost:#{bypass.port}"))

    assert %OAuth2.AccessToken{
             access_token: "ISSUED_ACCESS_TOKEN",
             other_params: %{},
             refresh_token: "ISSUED_REFRESH_TOKEN",
             token_type: "Bearer"
           } = client.token
  end

  test "token_expired?" do
    expired_token = %AccessToken{expires_at: :erlang.system_time(:second) - 30}
    actual_token = %AccessToken{expires_at: :erlang.system_time(:second) + 3600}
    assert OAuth.Impl.token_expired?(nil)
    assert OAuth.Impl.token_expired?(expired_token)
    assert OAuth.Impl.token_expired?(%Client{token: expired_token})

    refute OAuth.Impl.token_expired?(actual_token)
    refute OAuth.Impl.token_expired?(%Client{token: actual_token})
  end

  describe "creating new API client" do
    test "create new api client for default user ID" do
      assert %Client{
               request_opts: [],
               site: "http://localhost",
               strategy: DocuSign.OAuth.Impl,
               token: nil,
               token_method: :post,
               token_url: "/oauth/token",
               ref: %{
                 user_id: ":user-id:"
               }
             } = OAuth.Impl.client(site: "http://localhost")
    end

    test "create new api client for given user ID" do
      assert %Client{
               request_opts: [],
               site: "http://localhost",
               strategy: DocuSign.OAuth.Impl,
               token: nil,
               token_method: :post,
               token_url: "/oauth/token",
               ref: %{
                 user_id: ":other-user-id:"
               }
             } = OAuth.Impl.client(user_id: ":other-user-id:", site: "http://localhost")
    end
  end

  test "get_token" do
    assert %Client{
             params: %{
               "assertion" => _,
               "grant_type" => "urn:ietf:params:oauth:grant-type:jwt-bearer"
             }
           } = OAuth.Impl.get_token(OAuth.Impl.client(site: "http://localhost"), [], [])
  end

  test "refresh_token!", %{bypass: bypass} do
    now = :erlang.system_time(:second)

    client =
      OAuth.Impl.client(
        site: "http://localhost:#{bypass.port}",
        token: %AccessToken{
          expires_at: now + 3600,
          access_token: "TEST_TOKEN"
        }
      )

    Bypass.expect(bypass, "POST", "/oauth/token", fn conn ->
      Conn.resp(conn, 200, @token)
    end)

    assert %AccessToken{access_token: "TEST_TOKEN"} = OAuth.Impl.refresh_token!(client).token

    assert %AccessToken{access_token: "ISSUED_ACCESS_TOKEN"} =
             OAuth.Impl.refresh_token!(client, true).token

    expired_client = %Client{client | token: %AccessToken{expires_at: now - 3600}}

    assert %AccessToken{access_token: "ISSUED_ACCESS_TOKEN"} =
             OAuth.Impl.refresh_token!(expired_client).token
  end

  test "interval_refresh_token" do
    now = :erlang.system_time(:second)
    token = %AccessToken{expires_at: now + 3600}
    client = %Client{token: token}
    assert OAuth.Impl.interval_refresh_token(client) == 3590
  end

  test "get_client_info", %{bypass: bypass} do
    user_info = ~s({
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

    Bypass.expect_once(bypass, "GET", "/oauth/userinfo", fn conn ->
      conn
      |> Conn.put_resp_header("content-type", "application/json")
      |> Conn.resp(200, user_info)
    end)

    client = OAuth.Impl.client(site: "http://localhost:#{bypass.port}")

    info = OAuth.Impl.get_client_info(client)

    # == DocuSign.Util.map_keys_to_atoms(user_info)
    assert info == %{
             "accounts" => [
               %{
                 "account_id" => "61ac4bd1-c83c-4aa6-8654-d3b44a252f42",
                 "account_name" => "Tandem Equity LLC",
                 "base_uri" => "https://demo.docusign.net",
                 "is_default" => true
               }
             ],
             "created" => "2018-09-07T23:49:34.163",
             "email" => "neil@test.com",
             "family_name" => "Test",
             "given_name" => "Neil",
             "name" => "Neil Test1",
             "sub" => "84a39dd2-b972-48b2-929a-cf743466a4d5"
           }
  end

  describe "private key configuration" do
    setup %{bypass: bypass} do
      stub_token_request(bypass)
      :ok
    end

    # In v2.0.0, the :private_key option was removed
    test "uses private_key_file configuration", %{bypass: bypass} do
      Application.put_env(:docusign, :private_key_file, "test/support/test_key")

      assert log_of_get_token!(bypass) == ""
    end

    test "can be configured with private_key_file only", %{bypass: bypass} do
      # Only set private_key_file
      Application.delete_env(:docusign, :private_key_contents)
      Application.put_env(:docusign, :private_key_file, "test/support/test_key")

      assert log_of_get_token!(bypass) == ""
    end

    test "can be configured with private_key_contents only", %{bypass: bypass} do
      # Only set private_key_contents
      Application.delete_env(:docusign, :private_key_file)
      Application.put_env(:docusign, :private_key_contents, File.read!("test/support/test_key"))

      assert log_of_get_token!(bypass) == ""
    end

    test "raises without private key configuration", %{bypass: bypass} do
      # Remove all private key configs
      Application.delete_env(:docusign, :private_key_file)
      Application.delete_env(:docusign, :private_key_contents)

      assert_raise RuntimeError,
                   "No private key found in application environment. Please set :private_key_file or :private_key_contents.",
                   fn ->
                     OAuth.Impl.get_token!(
                       OAuth.Impl.client(site: "http://localhost:#{bypass.port}")
                     )
                   end
    end

    test "raises if multiple private key configuration keys are used", %{bypass: bypass} do
      Application.put_env(:docusign, :private_key_file, "test/support/test_key")
      Application.put_env(:docusign, :private_key_contents, File.read!("test/support/test_key"))

      assert_raise RuntimeError,
                   "Multiple DocuSign private keys were provided. Please use only one of :private_key_file or :private_key_contents.",
                   fn ->
                     OAuth.Impl.get_token!(
                       OAuth.Impl.client(site: "http://localhost:#{bypass.port}")
                     )
                   end
    end
  end

  defp stub_token_request(bypass) do
    Bypass.stub(bypass, "POST", "/oauth/token", fn conn ->
      Conn.resp(conn, 200, @token)
    end)
  end

  defp log_of_get_token!(bypass) do
    {_client, log} =
      with_log(fn ->
        OAuth.Impl.get_token!(OAuth.Impl.client(site: "http://localhost:#{bypass.port}"))
      end)

    log
  end
end
