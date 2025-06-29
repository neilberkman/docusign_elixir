defmodule DocuSign.SSLOptionsTest do
  use ExUnit.Case

  alias DocuSign.SSLOptions

  doctest DocuSign.SSLOptions

  describe "build/1" do
    test "returns default options when no config is set" do
      opts = SSLOptions.build()

      assert opts[:verify] == :verify_peer
      assert opts[:depth] == 3
      assert opts[:versions] == [:"tlsv1.2", :"tlsv1.3"]
      assert opts[:customize_hostname_check]
    end

    test "merges application config with defaults" do
      # Temporarily set application config
      original = Application.get_env(:docusign, :ssl_options)
      Application.put_env(:docusign, :ssl_options, verify: :verify_none, depth: 5)

      try do
        opts = SSLOptions.build()
        assert opts[:verify] == :verify_none
        assert opts[:depth] == 5
      after
        # Restore original config
        if original do
          Application.put_env(:docusign, :ssl_options, original)
        else
          Application.delete_env(:docusign, :ssl_options)
        end
      end
    end

    test "runtime options override all other options" do
      opts = SSLOptions.build(verify: :verify_none, depth: 1)

      assert opts[:verify] == :verify_none
      assert opts[:depth] == 1
    end

    test "expands file paths" do
      # Create a temporary file
      {:ok, path} = Briefly.create()

      opts = SSLOptions.build(cacertfile: path)
      assert opts[:cacertfile] == Path.expand(path)
    end

    test "raises on non-existent file paths" do
      assert_raise ArgumentError, ~r/non-existent file/, fn ->
        SSLOptions.build(cacertfile: "/non/existent/file.pem")
      end
    end

    test "filters nil values" do
      opts = SSLOptions.build(certfile: nil, keyfile: nil)

      refute Keyword.has_key?(opts, :certfile)
      refute Keyword.has_key?(opts, :keyfile)
    end

    test "auto-detects CA certificates when CAStore is available" do
      # This test assumes CAStore is available as a dependency
      if Code.ensure_loaded?(CAStore) do
        opts = SSLOptions.build()
        assert opts[:cacerts] || opts[:cacertfile]
      end
    end

    test "handles password-protected keys" do
      opts =
        SSLOptions.build(
          keyfile: "/path/to/key.pem",
          password: "secret",
          validate_files: false
        )

      assert opts[:password] == "secret"
      assert opts[:keyfile] == "/path/to/key.pem"
    end

    test "supports custom cipher suites" do
      ciphers = [
        "ECDHE-RSA-AES256-GCM-SHA384",
        "ECDHE-RSA-AES128-GCM-SHA256"
      ]

      opts = SSLOptions.build(ciphers: ciphers)
      assert opts[:ciphers] == ciphers
    end

    test "supports custom verification function" do
      verify_fun = fn _cert, _event, _state -> :valid end

      opts = SSLOptions.build(verify_fun: verify_fun)
      assert opts[:verify_fun] == verify_fun
    end
  end

  describe "system CA certificate detection" do
    test "finds system certificates on various platforms" do
      # This is more of a smoke test - actual paths depend on the system
      opts = SSLOptions.build()

      # Should have some form of CA certificates configured
      assert opts[:cacerts] || opts[:cacertfile] ||
               (opts[:cacerts] && is_list(opts[:cacerts]))
    end
  end

  describe "integration with Connection module" do
    test "Connection.request/2 accepts ssl_options" do
      # Ensure the module is loaded
      Code.ensure_loaded!(DocuSign.Connection)

      # Just verify the function exists and has the right arity
      assert function_exported?(DocuSign.Connection, :request, 2)
    end
  end
end
