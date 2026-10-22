defmodule DocuSign.PathParamEncodingTest do
  use ExUnit.Case, async: true

  alias DocuSign.Api.EnvelopeDocuments
  alias DocuSign.Connection
  alias DocuSign.TestHTTPServer

  test "generated API calls keep untrusted IDs in single path segments" do
    server = TestHTTPServer.open()
    account_id = "account-123"
    envelope_id = "E1?include=documents"
    document_id = "../../other/documents/1"

    oauth_client = %OAuth2.Client{
      token: %OAuth2.AccessToken{access_token: "test-token", token_type: "Bearer"}
    }

    {:ok, connection} =
      Connection.from_oauth_client(oauth_client,
        account_id: account_id,
        base_uri: "http://localhost:#{server.port}"
      )

    connection = %{connection | req: Req.merge(connection.req, retry: false)}

    expected_path =
      "/v2.1/accounts/account-123/envelopes/E1%3Finclude%3Ddocuments/documents/..%2F..%2Fother%2Fdocuments%2F1"

    TestHTTPServer.expect_once(server, "GET", expected_path, fn conn ->
      assert conn.request_path == expected_path

      assert Enum.map(conn.path_info, &URI.decode/1) ==
               ["v2.1", "accounts", account_id, "envelopes", envelope_id, "documents", document_id]

      assert conn.query_string == ""
      assert Plug.Conn.fetch_query_params(conn).query_params == %{}
      assert Plug.Conn.get_req_header(conn, "authorization") == ["Bearer test-token"]

      Plug.Conn.resp(conn, 200, "document")
    end)

    assert {:ok, "document"} =
             EnvelopeDocuments.documents_get_document(connection, account_id, document_id, envelope_id, [])
  end

  test "every generated API URL encodes its interpolated path parameters" do
    api_files = Path.wildcard(Path.expand("../../lib/docusign/api/*.ex", __DIR__))
    assert api_files != []

    unencoded =
      for file <- api_files,
          [url] <- Regex.scan(~r/\burl\(\s*"[^"]*"/, File.read!(file)),
          Regex.match?(~r/\#\{(?!encode_path_param\()/, url) do
        "#{Path.basename(file)}: #{url}"
      end

    assert unencoded == [], "Unencoded API path parameters:\n#{Enum.join(unencoded, "\n")}"
  end
end
