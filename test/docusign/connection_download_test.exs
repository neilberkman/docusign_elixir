defmodule DocuSign.ConnectionDownloadTest do
  use ExUnit.Case, async: true

  import Mock

  alias DocuSign.Connection

  describe "download_file/3" do
    test "delegates to FileDownloader.download/3" do
      mock_conn = %Connection{}
      url = "/test/url"
      opts = [strategy: :memory]

      expected_result = {:ok, {"content", "file.pdf", "application/pdf"}}

      with_mock DocuSign.FileDownloader, [:passthrough], download: fn ^mock_conn, ^url, ^opts -> expected_result end do
        assert expected_result == Connection.download_file(mock_conn, url, opts)
        assert called(DocuSign.FileDownloader.download(mock_conn, url, opts))
      end
    end

    test "uses default options when none provided" do
      mock_conn = %Connection{}
      url = "/test/url"

      with_mock DocuSign.FileDownloader, [:passthrough],
        download: fn ^mock_conn, ^url, [] -> {:ok, "/tmp/file.pdf"} end do
        assert {:ok, "/tmp/file.pdf"} == Connection.download_file(mock_conn, url)
        assert called(DocuSign.FileDownloader.download(mock_conn, url, []))
      end
    end

    test "passes through all download strategies" do
      mock_conn = %Connection{}
      url = "/test/url"

      # Test memory strategy
      with_mock DocuSign.FileDownloader, [:passthrough],
        download: fn ^mock_conn, ^url, [strategy: :memory] ->
          {:ok, {"content", "file.pdf", "application/pdf"}}
        end do
        result = Connection.download_file(mock_conn, url, strategy: :memory)
        assert {:ok, {"content", "file.pdf", "application/pdf"}} == result
      end

      # Test temp strategy
      with_mock DocuSign.FileDownloader, [:passthrough],
        download: fn ^mock_conn, ^url, [strategy: :temp] ->
          {:ok, "/tmp/file.pdf"}
        end do
        result = Connection.download_file(mock_conn, url, strategy: :temp)
        assert {:ok, "/tmp/file.pdf"} == result
      end

      # Test file strategy
      with_mock DocuSign.FileDownloader, [:passthrough],
        download: fn ^mock_conn, ^url, [strategy: :file, filename: "/path/file.pdf"] ->
          {:ok, "/path/file.pdf"}
        end do
        result = Connection.download_file(mock_conn, url, strategy: :file, filename: "/path/file.pdf")
        assert {:ok, "/path/file.pdf"} == result
      end
    end

    test "passes through error results" do
      mock_conn = %Connection{}
      url = "/test/url"
      error = {:error, {:http_error, 404, "Not found"}}

      with_mock DocuSign.FileDownloader, [:passthrough], download: fn ^mock_conn, ^url, [] -> error end do
        assert error == Connection.download_file(mock_conn, url)
      end
    end

    test "supports all FileDownloader options" do
      mock_conn = %Connection{}
      url = "/test/url"

      opts = [
        strategy: :temp,
        temp_options: [prefix: "docusign", suffix: ".pdf"],
        max_size: 10_000_000,
        validate_content_type: true,
        overwrite: false
      ]

      with_mock DocuSign.FileDownloader, [:passthrough],
        download: fn ^mock_conn, ^url, ^opts -> {:ok, "/tmp/docusign_123.pdf"} end do
        result = Connection.download_file(mock_conn, url, opts)
        assert {:ok, "/tmp/docusign_123.pdf"} == result
        assert called(DocuSign.FileDownloader.download(mock_conn, url, opts))
      end
    end
  end
end
