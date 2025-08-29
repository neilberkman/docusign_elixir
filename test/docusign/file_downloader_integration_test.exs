defmodule DocuSign.FileDownloaderIntegrationTest do
  use ExUnit.Case, async: true

  alias DocuSign.Connection
  alias DocuSign.FileDownloader

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "download with real DocuSign response headers" do
    test "handles real DocuSign content-disposition header format", %{bypass: bypass} do
      # This is the ACTUAL header format from DocuSign API
      # Found when running the livebook with real credentials
      pdf_content = "%PDF-1.5\n%real pdf content here"

      Bypass.expect_once(bypass, "GET", "/document", fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/pdf")
        |> Plug.Conn.put_resp_header(
          "content-disposition",
          ~s(file; filename="Embedded_Signing_Example.html.pdf"; documentid="1")
        )
        |> Plug.Conn.resp(200, pdf_content)
      end)

      # Create a mock connection that points to our bypass
      conn = %Connection{
        req: Req.new(base_url: "http://localhost:#{bypass.port}")
      }

      # Test memory download
      assert {:ok, {content, filename, content_type}} =
               FileDownloader.download(conn, "/document", strategy: :memory)

      assert content == pdf_content
      assert filename == "Embedded_Signing_Example.html.pdf"
      assert content_type == "application/pdf"
    end

    test "handles DocuSign envelope document download", %{bypass: bypass} do
      # Real response from DocuSign when downloading an envelope document
      pdf_content = File.read!("test/fixtures/sample.pdf")

      Bypass.expect_once(
        bypass,
        "GET",
        "/restapi/v2.1/accounts/17035828/envelopes/test-envelope-id/documents/1",
        fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/pdf")
          |> Plug.Conn.put_resp_header(
            "content-disposition",
            ~s(file; filename="Test_Document.pdf"; documentid="1")
          )
          |> Plug.Conn.resp(200, pdf_content)
        end
      )

      conn = %Connection{
        req: Req.new(base_url: "http://localhost:#{bypass.port}")
      }

      assert {:ok, {content, filename, content_type}} =
               FileDownloader.download(
                 conn,
                 "/restapi/v2.1/accounts/17035828/envelopes/test-envelope-id/documents/1",
                 strategy: :memory
               )

      assert content == pdf_content
      assert filename == "Test_Document.pdf"
      assert content_type == "application/pdf"
    end

    test "handles combined document download", %{bypass: bypass} do
      # When downloading combined documents, DocuSign uses different header format
      pdf_content = "%PDF-1.5\n%combined"

      Bypass.expect_once(
        bypass,
        "GET",
        "/restapi/v2.1/accounts/17035828/envelopes/test-id/documents/combined",
        fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/pdf")
          |> Plug.Conn.put_resp_header(
            "content-disposition",
            "inline; filename=\"Combined_Document.pdf\""
          )
          |> Plug.Conn.resp(200, pdf_content)
        end
      )

      conn = %Connection{
        req: Req.new(base_url: "http://localhost:#{bypass.port}")
      }

      assert {:ok, {content, filename, _content_type}} =
               FileDownloader.download(
                 conn,
                 "/restapi/v2.1/accounts/17035828/envelopes/test-id/documents/combined",
                 strategy: :memory
               )

      assert content == pdf_content
      assert filename == "Combined_Document.pdf"
    end
  end
end
