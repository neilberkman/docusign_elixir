defmodule DocuSign.TestTLS do
  @moduledoc false

  @doc """
  Generates a throwaway certificate chain for a local HTTPS test server.

  Returns the `server_config` and `client_config` keyword lists produced by
  `:public_key.pkix_test_data/1`. The server's leaf certificate carries a
  `localhost` DNS name and a `127.0.0.1` IP address as subject alternative names,
  so hostname verification passes for `https://localhost:<port>` and
  `https://127.0.0.1:<port>`. `client_config[:cacerts]` holds the DER-encoded
  CA certificates a client needs to verify that server; the system CA bundle
  does not contain them.
  """
  @spec chains() :: %{server_config: keyword(), client_config: keyword()}
  def chains do
    san = {:Extension, {2, 5, 29, 17}, false, [dNSName: ~c"localhost", iPAddress: <<127, 0, 0, 1>>]}
    spec = [key: {:namedCurve, :secp256r1}, digest: :sha256]

    :public_key.pkix_test_data(%{
      server_chain: %{root: spec, intermediates: [], peer: spec ++ [extensions: [san]]},
      client_chain: %{root: spec, intermediates: [], peer: spec}
    })
  end

  @doc """
  Transport options for `DocuSign.TestHTTPServer.open/1` with `scheme: :https`.
  """
  @spec server_transport_options(keyword()) :: keyword()
  def server_transport_options(server_config) do
    Keyword.take(server_config, [:cert, :key])
  end
end
