defmodule DocuSign.FileDownloaderTest do
  use ExUnit.Case, async: true

  import Mock

  alias DocuSign.Connection
  alias DocuSign.FileDownloader

  describe "extract_filename_from_header/1" do
    test "extracts filename from standard Content-Disposition header" do
      assert {:ok, "document.pdf"} =
               FileDownloader.extract_filename_from_header("attachment; filename=document.pdf")
    end

    test "extracts filename from quoted Content-Disposition header" do
      assert {:ok, "document.pdf"} =
               FileDownloader.extract_filename_from_header("attachment; filename=\"document.pdf\"")

      # Test with spaces in filename
      assert {:ok, "My Document.pdf"} =
               FileDownloader.extract_filename_from_header("attachment; filename=\"My Document.pdf\"")
    end

    test "extracts filename from RFC 6266 encoded header" do
      assert {:ok, "document name.pdf"} =
               FileDownloader.extract_filename_from_header("attachment; filename*=UTF-8''document%20name.pdf")
    end

    test "handles header without filename" do
      assert {:error, :no_filename} =
               FileDownloader.extract_filename_from_header("attachment")
    end

    test "extracts filename ignoring other parameters" do
      assert {:ok, "document.pdf"} =
               FileDownloader.extract_filename_from_header("attachment; filename=document.pdf; size=12345")
    end

    test "handles case-insensitive filename parameter" do
      assert {:ok, "document.pdf"} =
               FileDownloader.extract_filename_from_header("attachment; FILENAME=document.pdf")
    end
  end

  describe "sanitize_filename/1" do
    test "removes path components" do
      assert "malicious.pdf" = FileDownloader.sanitize_filename("../../malicious.pdf")
      assert "file.pdf" = FileDownloader.sanitize_filename("/etc/passwd/../file.pdf")
    end

    test "removes invalid filename characters" do
      assert "file.pdf" = FileDownloader.sanitize_filename("file<>:\"|?*.pdf")
      assert "documentfile.pdf" = FileDownloader.sanitize_filename("document\\file.pdf")
    end

    test "handles empty filename" do
      assert "download" = FileDownloader.sanitize_filename("")
      assert "download" = FileDownloader.sanitize_filename("   ")
    end

    test "preserves valid filenames" do
      assert "document.pdf" = FileDownloader.sanitize_filename("document.pdf")
      assert "my_file-123.pdf" = FileDownloader.sanitize_filename("my_file-123.pdf")
    end
  end

  describe "ensure_unique_filename/1" do
    test "returns original filename if file doesn't exist" do
      non_existent_path = "/tmp/non_existent_file_#{:rand.uniform(10_000)}.pdf"
      assert ^non_existent_path = FileDownloader.ensure_unique_filename(non_existent_path)
    end

    test "appends number if file exists" do
      with_mock File, [:passthrough], exists?: fn path -> path == "/tmp/test.pdf" end do
        unique_path = FileDownloader.ensure_unique_filename("/tmp/test.pdf")
        assert unique_path == "/tmp/test_1.pdf"
      end
    end

    test "finds next available number" do
      existing_files = ["/tmp/test.pdf", "/tmp/test_1.pdf", "/tmp/test_2.pdf"]

      with_mock File, [:passthrough], exists?: fn path -> path in existing_files end do
        unique_path = FileDownloader.ensure_unique_filename("/tmp/test.pdf")
        assert unique_path == "/tmp/test_3.pdf"
      end
    end
  end

  describe "download_to_memory/3" do
    test "downloads file to memory with metadata" do
      mock_response = %Req.Response{
        body: "PDF content here",
        headers: [
          {"content-type", "application/pdf"},
          {"content-disposition", ["attachment; filename=test.pdf"]}
        ],
        status: 200
      }

      mock_conn = %Connection{}

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        assert {:ok, {content, filename, content_type}} =
                 FileDownloader.download_to_memory(mock_conn, "/test/url")

        assert content == "PDF content here"
        assert filename == "test.pdf"
        assert content_type == "application/pdf"
      end
    end

    test "handles missing content-disposition header" do
      mock_response = %Req.Response{
        body: "PDF content",
        headers: [{"content-type", "application/pdf"}],
        status: 200
      }

      mock_conn = %Connection{}

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        assert {:ok, {content, filename, content_type}} =
                 FileDownloader.download_to_memory(mock_conn, "/test/url")

        assert content == "PDF content"
        assert String.contains?(filename, "docusign_download_")
        assert String.ends_with?(filename, ".pdf")
        assert content_type == "application/pdf"
      end
    end
  end

  describe "download_to_temp/3" do
    test "downloads file to temporary location" do
      mock_response = %Req.Response{
        body: "PDF content here",
        headers: [
          {"content-type", "application/pdf"},
          {"content-disposition", ["attachment; filename=test.pdf"]}
        ],
        status: 200
      }

      mock_conn = %Connection{}

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        with_mock Temp, [:passthrough],
          track: fn -> {:ok, :tracked} end,
          open: fn _opts, _func ->
            # Simulate temp file creation - don't call the function since we're mocking
            temp_path = "/tmp/test_#{:rand.uniform(10_000)}.pdf"
            {:ok, temp_path}
          end do
          assert {:ok, temp_path} = FileDownloader.download_to_temp(mock_conn, "/test/url")
          assert String.contains?(temp_path, "/tmp/")
          assert String.ends_with?(temp_path, ".pdf")
        end
      end
    end

    test "uses custom temp options" do
      mock_response = %Req.Response{
        body: "content",
        headers: [{"content-type", "text/plain"}],
        status: 200
      }

      mock_conn = %Connection{}

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        with_mock Temp, [:passthrough],
          track: fn -> {:ok, :tracked} end,
          open: fn opts, _func ->
            # Verify custom options are passed through
            assert Keyword.get(opts, :prefix) == "custom"
            assert Keyword.get(opts, :suffix) == ".txt"

            temp_path = "/tmp/custom_123.txt"
            {:ok, temp_path}
          end do
          assert {:ok, temp_path} =
                   FileDownloader.download_to_temp(mock_conn, "/test/url",
                     temp_options: [prefix: "custom", suffix: ".txt"]
                   )

          assert temp_path == "/tmp/custom_123.txt"
        end
      end
    end
  end

  describe "download_to_file/4" do
    test "downloads file to specified path" do
      mock_response = %Req.Response{
        body: "file content",
        headers: [{"content-type", "application/pdf"}],
        status: 200
      }

      mock_conn = %Connection{}
      file_path = "/tmp/test_download_#{:rand.uniform(10_000)}.pdf"

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        with_mock File, [:passthrough],
          mkdir_p: fn _dir -> :ok end,
          write: fn ^file_path, "file content" -> :ok end,
          exists?: fn ^file_path -> false end do
          assert {:ok, ^file_path} =
                   FileDownloader.download_to_file(mock_conn, "/test/url", file_path)
        end
      end
    end

    test "creates directory if it doesn't exist" do
      mock_response = %Req.Response{
        body: "content",
        headers: [{"content-type", "text/plain"}],
        status: 200
      }

      mock_conn = %Connection{}
      file_path = "/some/deep/path/file.txt"

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        with_mock File, [:passthrough],
          mkdir_p: fn "/some/deep/path" -> :ok end,
          write: fn ^file_path, "content" -> :ok end,
          exists?: fn ^file_path -> false end do
          assert {:ok, ^file_path} =
                   FileDownloader.download_to_file(mock_conn, "/test/url", file_path)
        end
      end
    end

    test "handles file write errors" do
      mock_response = %Req.Response{
        body: "content",
        headers: [{"content-type", "text/plain"}],
        status: 200
      }

      mock_conn = %Connection{}
      file_path = "/readonly/file.txt"

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        with_mock File, [:passthrough],
          mkdir_p: fn _dir -> :ok end,
          write: fn ^file_path, _content -> {:error, :eacces} end,
          exists?: fn ^file_path -> false end do
          assert {:error, {:file_write_error, :eacces}} =
                   FileDownloader.download_to_file(mock_conn, "/test/url", file_path)
        end
      end
    end
  end

  describe "download/3 with validation" do
    test "validates file size when max_size is set" do
      large_content = String.duplicate("x", 1000)

      mock_response = %Req.Response{
        body: large_content,
        headers: [
          {"content-type", "text/plain"},
          {"content-length", "1000"}
        ],
        status: 200
      }

      mock_conn = %Connection{}

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        assert {:error, {:file_too_large, 1000, 500}} =
                 FileDownloader.download(mock_conn, "/test/url", max_size: 500)
      end
    end

    test "validates content type when enabled" do
      mock_response = %Req.Response{
        body: "content",
        headers: [{"content-type", "application/javascript"}],
        status: 200
      }

      mock_conn = %Connection{}

      with_mock Application, [:passthrough],
        get_env: fn
          :docusign, :file_downloader, [] ->
            [allowed_content_types: ["application/pdf", "text/html"]]

          app, key, default ->
            # Pass through other calls
            Application.get_env(app, key, default)
        end do
        with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
          assert {:error, {:invalid_content_type, "application/javascript"}} =
                   FileDownloader.download(mock_conn, "/test/url", validate_content_type: true)
        end
      end
    end

    test "skips content type validation when disabled" do
      mock_response = %Req.Response{
        body: "content",
        headers: [{"content-type", "application/javascript"}],
        status: 200
      }

      mock_conn = %Connection{}

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        with_mock Temp, [:passthrough],
          track: fn -> {:ok, :tracked} end,
          open: fn _opts, _func ->
            temp_path = "/tmp/test.js"
            {:ok, temp_path}
          end do
          assert {:ok, temp_path} =
                   FileDownloader.download(mock_conn, "/test/url", validate_content_type: false)

          assert temp_path == "/tmp/test.js"
        end
      end
    end
  end

  describe "download/3 error handling" do
    test "handles HTTP errors" do
      mock_response = %Req.Response{
        body: "Not found",
        status: 404
      }

      mock_conn = %Connection{}

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:ok, mock_response} end do
        assert {:error, {:http_error, 404, "Not found"}} =
                 FileDownloader.download(mock_conn, "/test/url")
      end
    end

    test "handles connection errors" do
      mock_conn = %Connection{}

      with_mock DocuSign.Connection, [:passthrough], request: fn _conn, _opts -> {:error, :timeout} end do
        assert {:error, :timeout} = FileDownloader.download(mock_conn, "/test/url")
      end
    end
  end

  describe "cleanup_temp_files/0" do
    test "calls Temp.cleanup/0" do
      with_mock Temp, [:passthrough], cleanup: fn -> :ok end do
        assert :ok = FileDownloader.cleanup_temp_files()
        assert called(Temp.cleanup())
      end
    end
  end
end
