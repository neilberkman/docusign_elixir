defmodule DocuSign.OAuth.ImplTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  alias DocuSign.OAuth
  alias DocuSign.OAuth.Impl
  alias OAuth2.{AccessToken, Client}
  alias Plug.Conn

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "client/1" do
    test "creates client with default options" do
      Application.put_env(:docusign, :client_id, "test-client-id")
      Application.put_env(:docusign, :hostname, "test.docusign.com")

      client = Impl.client()

      assert client.client_id == "test-client-id"
      assert client.site == "https://test.docusign.com"
      assert client.authorize_url == "oauth/auth?response_type=code&scope=signature%20impersonation"
    end

    test "allows overriding site" do
      Application.put_env(:docusign, :client_id, "test-client-id")
      Application.put_env(:docusign, :hostname, "test.docusign.com")

      client = Impl.client(site: "https://custom.site.com")

      assert client.site == "https://custom.site.com"
    end
  end

  describe "get_token!/2" do
    setup %{bypass: bypass} do
      Application.put_env(:docusign, :client_id, "test-client-id")
      Application.delete_env(:docusign, :private_key_file)
      Application.put_env(:docusign, :private_key_contents, test_private_key())
      Application.put_env(:docusign, :user_id, "test-user-id")

      on_exit(fn ->
        Application.delete_env(:docusign, :client_id)
        Application.delete_env(:docusign, :private_key_contents)
        Application.delete_env(:docusign, :user_id)
        Application.delete_env(:docusign, :token_signer)
        # Restore test config
        Application.put_env(:docusign, :private_key_file, "test/support/test_key")
      end)

      {:ok, bypass: bypass}
    end

    test "successfully gets token", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        body_params = URI.decode_query(body)

        assert body_params["grant_type"] == "urn:ietf:params:oauth:grant-type:jwt-bearer"
        assert body_params["assertion"] =~ "."

        conn
        |> Conn.put_resp_content_type("application/json")
        |> Conn.resp(
          200,
          Jason.encode!(%{
            "access_token" => "test-access-token",
            "expires_in" => 3600,
            "scope" => "signature",
            "token_type" => "Bearer"
          })
        )
      end)

      client = Impl.client(token_url: "http://localhost:#{bypass.port}/oauth/token")
      %Client{token: token} = Impl.get_token!(client, [])

      assert %AccessToken{
               access_token: "test-access-token",
               expires_at: expires_at,
               token_type: "Bearer"
             } = token

      assert expires_at > :os.system_time(:second)
    end

    test "raises on error response", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        body_params = URI.decode_query(body)

        assert body_params["grant_type"] == "urn:ietf:params:oauth:grant-type:jwt-bearer"
        assert body_params["assertion"] =~ "."

        conn
        |> Conn.put_resp_content_type("application/json")
        |> Conn.resp(400, Jason.encode!(%{"error" => "invalid_grant"}))
      end)

      client = Impl.client(token_url: "http://localhost:#{bypass.port}/oauth/token")

      assert_raise OAuth2.Error, ~r/Server responded with status: 400/, fn ->
        Impl.get_token!(client, [])
      end
    end

    test "raises on network error", %{bypass: bypass} do
      Bypass.down(bypass)

      client = Impl.client(token_url: "http://localhost:#{bypass.port}/oauth/token")

      assert_raise OAuth2.Error, fn ->
        Impl.get_token!(client, [])
      end
    end
  end

  describe "refresh_token!/1" do
    test "refresh_token! refreshes when forced" do
      bypass = Bypass.open()
      Application.put_env(:docusign, :client_id, "test-client-id")
      Application.delete_env(:docusign, :private_key_file)
      Application.put_env(:docusign, :private_key_contents, test_private_key())
      Application.put_env(:docusign, :user_id, "test-user-id")

      on_exit(fn ->
        Application.delete_env(:docusign, :client_id)
        Application.delete_env(:docusign, :private_key_contents)
        Application.delete_env(:docusign, :user_id)
        Application.delete_env(:docusign, :token_signer)
        # Restore test config
        Application.put_env(:docusign, :private_key_file, "test/support/test_key")
      end)

      # Mock a successful token response
      Bypass.expect_once(bypass, "POST", "/oauth/token", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        body_params = URI.decode_query(body)

        assert body_params["grant_type"] == "urn:ietf:params:oauth:grant-type:jwt-bearer"
        assert body_params["assertion"] =~ "."

        conn
        |> Conn.put_resp_content_type("application/json")
        |> Conn.resp(
          200,
          Jason.encode!(%{
            "access_token" => "refreshed-token",
            "expires_in" => 3600,
            "token_type" => "Bearer"
          })
        )
      end)

      # Use the actual refresh_token! function from OAuth.Impl
      client = OAuth.Impl.client(token_url: "http://localhost:#{bypass.port}/oauth/token")
      refreshed_client = OAuth.Impl.refresh_token!(client, true)

      assert refreshed_client.token.access_token == "refreshed-token"
    end
  end

  describe "token_expired?/1" do
    test "returns true for nil token" do
      assert Impl.token_expired?(nil)
    end

    test "returns true for client with nil token" do
      client = %Client{token: nil}
      assert Impl.token_expired?(client)
    end

    test "returns false for valid token" do
      token = %AccessToken{
        access_token: "test",
        expires_at: :os.system_time(:second) + 3600
      }

      refute Impl.token_expired?(token)
    end

    test "returns true for expired token" do
      token = %AccessToken{
        access_token: "test",
        expires_at: :os.system_time(:second) - 3600
      }

      assert Impl.token_expired?(token)
    end
  end

  describe "get_client_info/1" do
    test "returns client info on success" do
      bypass = Bypass.open()

      Bypass.expect_once(bypass, "GET", "/oauth/userinfo", fn conn ->
        conn
        |> Conn.put_resp_content_type("application/json")
        |> Conn.resp(
          200,
          Jason.encode!(%{
            "email" => "test@example.com",
            "name" => "Test User",
            "sub" => "test-user-id"
          })
        )
      end)

      client = %Client{
        site: "http://localhost:#{bypass.port}",
        token: %AccessToken{access_token: "test-token"}
      }

      info = Impl.get_client_info(client)

      # Info will be a JSON string based on the response body handling
      assert is_binary(info)
      decoded = Jason.decode!(info)
      assert decoded["sub"] == "test-user-id"
      assert decoded["name"] == "Test User"
      assert decoded["email"] == "test@example.com"
    end

    test "returns nil and logs error on failure" do
      bypass = Bypass.open()

      Bypass.expect_once(bypass, "GET", "/oauth/userinfo", fn conn ->
        Conn.resp(conn, 401, "Unauthorized")
      end)

      client = %Client{
        site: "http://localhost:#{bypass.port}",
        token: %AccessToken{access_token: "invalid-token"}
      }

      assert capture_log(fn ->
               assert Impl.get_client_info(client) == nil
             end) =~ "Failed to get client info"
    end
  end

  describe "interval_refresh_token/1" do
    test "calculates refresh interval" do
      expires_at = :os.system_time(:second) + 3600

      client = %Client{
        token: %AccessToken{
          expires_at: expires_at
        }
      }

      interval = Impl.interval_refresh_token(client)

      # Should be approximately 3590 seconds (3600 - 10)
      assert interval > 3580 and interval <= 3590
    end
  end

  describe "error handling" do
    test "raises when no private key configured" do
      Application.put_env(:docusign, :client_id, "test-client-id")
      Application.put_env(:docusign, :hostname, "test.docusign.com")
      Application.put_env(:docusign, :user_id, "test-user-id")
      Application.delete_env(:docusign, :private_key_file)
      Application.delete_env(:docusign, :private_key_contents)
      Application.delete_env(:docusign, :token_signer)

      on_exit(fn ->
        Application.delete_env(:docusign, :client_id)
        Application.delete_env(:docusign, :user_id)
        # Restore test config
        Application.put_env(:docusign, :private_key_file, "test/support/test_key")
      end)

      client = Impl.client()

      assert_raise RuntimeError, ~r/No private key found/, fn ->
        Impl.get_token!(client)
      end
    end
  end

  defp test_private_key do
    """
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEA0Z3VS5JJcds3xfn/ygWyF32ytt6TpJlN4rAa2JM4fw9SvliE
    yMSrtDZ0MZLH4SI88XcS8HjRGGVUTTU3xpwLtyG8pnQiOiVJUfuzy3RpwCJwQWMJ
    KmVdmCEQQ1ebSAZIueJTpKKYS61E6sf/+rJmPkGGA+cEdEL0qpVYj5RB2L3F0sxK
    jOeeh0fLLqBLtyLdmLXDsnlEvW2J4E8K7X9zto4Y0Je9LluQGxAXBlp4Vfwzf6Ec
    cw9spkfKBWgkUWkdcN5FkaMPkLwVQcqPGPFI+aYCphQPFVlFgAwLoLretwJnT5Dj
    0IRZOV4qrz6AtSkHbJ2IvGwPvkRTuTLK+gi0DwIDAQABAoIBAQDBKJH9D6kkMSeW
    bJgDh1vWlxKqL8lOQCiI5cUGnGgP3/OQXoCAVhOBhbHte4nOxVwATy/LM8Zi+/bq
    cM8LWOdQNXDXJ2hpYU8sUHtFbs2bVZhTwnNMM6CTidiHGGlIHBhxQpbhzXlk0w8F
    pJ4TG5TmVbCnDF1dZ6K/s/o2NFq6u5hGmDfF8YhJMRq5kK3s1XsZJ5BQJHLUgKJD
    v7iT0nUaUvKeHRAajYzf0gCBhDKLZfPVaZkWxOCIR9Y/0JAGpPHCBJPj7pZ9fQKm
    xM2ZTEkJLPF2CP3zdwGHGEYEShvdJPjLQOM4SAr4JepCCaEZKVLKdmfBUg+FMdU+
    Gl5xUtsRAoGBAOyL5UCYA7lmFB2M2r5SLnJOgBVlmThQx6pXaKjp3MVAZ1YVUIHg
    CXmXEPjiMfvQk9sLmatPsDQdPWEYlWLKa/9zQWlEQDRcDQvVJFR8fAugOUI8v2dh
    Bi8Hcmb81Kb8VDHQPbkqLuPPMvQ4KGxGgQcw4ug0rR0c7f0F6vC4s0aZAoGBAOLc
    NJFaKfcH3y0wVSPar6kF0MRJNnKFkEcRFNkbihZSB3lbPkXoEooXsPTWJjEe8K8X
    lMSYCQhqBLJOmMLcGkCZTBYMQhZzZCR68TNDQt+/LKomY8L+qyLQdG+rPhUIQXZt
    jIaXmPCGEUH7nSFU6u2QgvHQ1ivUgH+xLhmPJCYXAoGBAOqyhLqcHLMEDyR6NjQr
    RphqCQFUa3SCW7vNNBfU6cmF9rCqsOC0Pu5e0n7xrN7M0hKdb3QVehyPOFTqFHhw
    JAYYUUMw72P8FQLVBHhe+lR7nNnqI6vsJBzy0JAVgwYpH1hcvKE5cfpMkJnbMXAF
    FHvBvkPAm2JhYLXoUUfwNbZRAoGADKfvxCN+rMVJPWCB8Rm5UIVeN1sNRb3gIni8
    eUvv6xNA2qPcQFbmFpQVOLiKcQKFKU4OSa2rGdMVNZG8V3UznM/NG3V3Hxek5S3l
    IvanhNVrFeMG6ivDpFa6Gf9p6Xwp8W5r6OfmPeV2mFR3N1qWPQpUKfWEou4bIa7P
    3nJF6+0CgYBVGqn1DJT4tp5CZ/7O0OCDF8CNjJuMJf3Y9T1Z7WixqBTXkCh8l7QB
    pxx4hH1LAWzV4wbxMKdILa4LYxYWLcF4moYZNKd1trM7fNcVTBEeQCDwCaIXEQDR
    82C2dK9tNXKDKPLSXA7kxSPRX8lXXbMWj6Ga8bgFqLdOcIDYQ2H7bg==
    -----END RSA PRIVATE KEY-----
    """
  end
end
