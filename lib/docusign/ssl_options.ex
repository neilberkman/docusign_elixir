defmodule DocuSign.SSLOptions do
  @moduledoc """
  Provides SSL configuration options for DocuSign API connections.

  This module handles SSL/TLS configuration for secure connections to DocuSign's API,
  supporting custom certificates, verification options, and client authentication.

  ## Configuration

  SSL options can be configured at the application level:

      config :docusign, :ssl_options,
        verify: :verify_peer,
        cacertfile: "/path/to/ca-bundle.crt",
        certfile: "/path/to/client-cert.pem",
        keyfile: "/path/to/client-key.pem",
        depth: 3,
        customize_hostname_check: [
          match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
        ]

  ## Options

  * `:verify` - How to verify the server certificate
    * `:verify_peer` - Verify the server certificate (default)
    * `:verify_none` - Don't verify the server certificate (not recommended)

  * `:cacertfile` - Path to CA certificate bundle file
  * `:cacerts` - List of DER-encoded CA certificates
  * `:certfile` - Path to client certificate file (for mutual TLS)
  * `:keyfile` - Path to client private key file (for mutual TLS)
  * `:password` - Password for encrypted private key
  * `:depth` - Maximum certificate chain verification depth (default: 3)
  * `:verify_fun` - Custom verification function
  * `:customize_hostname_check` - Hostname verification options
  * `:versions` - Allowed TLS versions (default: [:"tlsv1.2", :"tlsv1.3"])
  * `:ciphers` - Allowed cipher suites

  ## Security Considerations

  * Always use `:verify_peer` in production
  * Keep CA certificates up to date
  * Use strong cipher suites
  * Enable hostname verification
  """

  @doc """
  Builds SSL options from application configuration and runtime options.

  ## Examples

      iex> opts = DocuSign.SSLOptions.build()
      iex> opts[:verify]
      :verify_peer
      iex> opts[:depth]
      3

      iex> opts = DocuSign.SSLOptions.build(verify: :verify_none)
      iex> opts[:verify]
      :verify_none

      iex> opts = DocuSign.SSLOptions.build(depth: 5)
      iex> opts[:depth]
      5
  """
  @spec build(keyword()) :: keyword()
  def build(opts \\ []) do
    {validate, opts} = Keyword.pop(opts, :validate_files, true)

    default_ssl_opts()
    |> Keyword.merge(app_ssl_options())
    |> Keyword.merge(auto_detect_cacerts())
    |> Keyword.merge(opts)
    |> then(fn opts ->
      if validate do
        validate_and_expand_paths(opts)
      else
        opts
      end
    end)
    |> filter_nil_values()
  end

  defp default_ssl_opts do
    [
      verify: :verify_peer,
      depth: 3,
      versions: [:"tlsv1.2", :"tlsv1.3"],
      customize_hostname_check: [
        match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
      ]
    ]
  end

  # Private functions

  defp app_ssl_options do
    Application.get_env(:docusign, :ssl_options, [])
  end

  defp auto_detect_cacerts do
    app_opts = app_ssl_options()

    cond do
      # User already specified CA certs
      Keyword.has_key?(app_opts, :cacertfile) or
          Keyword.has_key?(app_opts, :cacerts) ->
        []

      # Try system CA certificates first
      cacertfile = find_system_cacerts() ->
        [cacertfile: cacertfile]

      # Use CAStore if available as a dependency
      Code.ensure_loaded?(CAStore) ->
        if function_exported?(CAStore, :file_path, 0) do
          [cacertfile: CAStore.file_path()]
        else
          []
        end

      # No system certs found, no CAStore
      true ->
        []
    end
  end

  defp find_system_cacerts do
    locations = [
      # macOS
      "/etc/ssl/cert.pem",
      "/usr/local/etc/openssl/cert.pem",
      "/opt/homebrew/etc/ca-certificates/cert.pem",
      # Linux
      "/etc/ssl/certs/ca-certificates.crt",
      "/etc/ssl/certs/ca-bundle.crt",
      "/etc/pki/tls/certs/ca-bundle.crt",
      # Alpine
      "/etc/ssl/certs/ca-certificates.crt"
    ]

    Enum.find(locations, &File.exists?/1)
  end

  defp validate_and_expand_paths(opts) do
    Enum.map(opts, fn
      {key, path} when key in [:cacertfile, :certfile, :keyfile] and is_binary(path) ->
        expanded_path = Path.expand(path)

        if File.exists?(expanded_path) do
          {key, expanded_path}
        else
          raise ArgumentError,
                "SSL option #{key} points to non-existent file: #{path}"
        end

      other ->
        other
    end)
  end

  defp filter_nil_values(opts) do
    Enum.reject(opts, fn {_k, v} -> is_nil(v) end)
  end
end
