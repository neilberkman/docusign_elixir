defmodule DocuSign.ConnectionDownloadTest do
  @moduledoc """
  Tests for Connection.download_file/3 delegation.

  Since this is just a simple delegation to FileDownloader, we test it
  without mocks to avoid async test issues.
  """
  use ExUnit.Case, async: true

  alias DocuSign.Connection

  describe "download_file/3" do
    test "calls FileDownloader.download with correct arguments" do
      # Since download_file is just a delegation, we test it with a real HTTP call
      # using a local test server to ensure arguments are passed correctly
      server = DocuSign.TestHTTPServer.open()

      DocuSign.TestHTTPServer.expect_once(server, "GET", "/test/document.pdf", fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-disposition", ~s(attachment; filename="doc.pdf"))
        |> Plug.Conn.put_resp_header("content-type", "application/pdf")
        |> Plug.Conn.resp(200, "PDF content here")
      end)

      conn = %Connection{
        req: Req.new(base_url: "http://localhost:#{server.port}")
      }

      # Test that arguments are passed through correctly
      result = Connection.download_file(conn, "/test/document.pdf", strategy: :memory)
      assert {:ok, {"PDF content here", "doc.pdf", "application/pdf"}} = result
    end

    test "passes through errors from FileDownloader" do
      # Test error handling
      server = DocuSign.TestHTTPServer.open()

      DocuSign.TestHTTPServer.expect_once(server, "GET", "/missing", fn conn ->
        Plug.Conn.resp(conn, 404, "Not found")
      end)

      conn = %Connection{
        req: Req.new(base_url: "http://localhost:#{server.port}")
      }

      assert {:error, {:http_error, 404, "Not found"}} =
               Connection.download_file(conn, "/missing")
    end

    test "supports all FileDownloader options" do
      # Create a temp file to test file strategy
      temp_path = Path.join(System.tmp_dir!(), "test_download_#{:rand.uniform(10_000)}.pdf")

      server = DocuSign.TestHTTPServer.open()

      DocuSign.TestHTTPServer.expect_once(server, "GET", "/download", fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/pdf")
        |> Plug.Conn.resp(200, "File content")
      end)

      conn = %Connection{
        req: Req.new(base_url: "http://localhost:#{server.port}")
      }

      # Test with various options to ensure they're passed through
      assert {:ok, ^temp_path} =
               Connection.download_file(conn, "/download",
                 strategy: :file,
                 filename: temp_path,
                 overwrite: true
               )

      # Clean up
      File.rm(temp_path)
    end
  end
end
