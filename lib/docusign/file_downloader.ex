defmodule DocuSign.FileDownloader do
  @moduledoc """
  File download utilities for DocuSign documents and attachments.

  This module provides functionality for downloading files from DocuSign APIs
  with automatic filename extraction from Content-Disposition headers,
  flexible file handling options, and support for multiple file formats.

  ## Features

  - Automatic filename extraction from Content-Disposition headers
  - Configurable temporary file management
  - Multiple download strategies (to file, to memory, streaming)
  - Support for various file formats (PDF, HTML, images, etc.)
  - Filename sanitization and collision handling
  - Content-Type detection and validation

  ## Usage

      # Download to a temporary file
      {:ok, path} = DocuSign.FileDownloader.download_to_temp(conn, url)

      # Download to a specific path
      {:ok, path} = DocuSign.FileDownloader.download_to_file(conn, url, "/path/to/file.pdf")

      # Download to memory
      {:ok, {content, filename, content_type}} = DocuSign.FileDownloader.download_to_memory(conn, url)

      # Download with options
      {:ok, result} = DocuSign.FileDownloader.download(conn, url,
        strategy: :file,
        filename: "custom_name.pdf",
        temp_dir: "/custom/temp"
      )

  ## Configuration

  You can configure the file downloader options:

      config :docusign, :file_downloader,
        max_filename_length: 255,
        sanitize_filenames: true,
        allowed_content_types: ~w(application/pdf text/html image/png image/jpeg),
        track_temp_files: true

  """

  alias Connection

  require Logger

  @type download_strategy :: :file | :memory | :temp | :stream
  @type download_result ::
          {:ok, binary()}
          | {:ok, {binary(), String.t(), String.t()}}
          | {:ok, String.t()}
          | {:error, term()}

  @type download_options :: [
          strategy: download_strategy(),
          filename: String.t() | nil,
          temp_options: keyword() | nil,
          max_size: non_neg_integer() | nil,
          validate_content_type: boolean(),
          overwrite: boolean()
        ]

  @default_options [
    strategy: :temp,
    filename: nil,
    temp_options: [],
    max_size: nil,
    validate_content_type: true,
    overwrite: false
  ]

  @doc """
  Downloads a file from the given URL using the DocuSign connection.

  ## Options

  - `:strategy` - Download strategy (`:file`, `:memory`, `:temp`, `:stream`)
  - `:filename` - Custom filename (overrides Content-Disposition)
  - `:temp_options` - Options passed to `Temp` library for temporary files
  - `:max_size` - Maximum file size in bytes
  - `:validate_content_type` - Whether to validate content type
  - `:overwrite` - Whether to overwrite existing files

  ## Returns

  - `{:ok, content}` when strategy is `:memory`
  - `{:ok, {content, filename, content_type}}` when strategy is `:memory` with metadata
  - `{:ok, filepath}` when strategy is `:file` or `:temp`
  - `{:error, reason}` on failure

  ## Examples

      # Download envelope document to temporary file
      {:ok, temp_path} = DocuSign.FileDownloader.download(conn,
        "/v2.1/accounts/123/envelopes/456/documents/1")

      # Download with custom temp options
      {:ok, path} = DocuSign.FileDownloader.download(conn, url,
        temp_options: [prefix: "contract", suffix: ".pdf"])

      # Download to memory for processing
      {:ok, {content, filename, content_type}} = DocuSign.FileDownloader.download(conn, url,
        strategy: :memory)

  """
  @spec download(DocuSign.Connection.t(), String.t(), download_options()) :: download_result()
  def download(conn, url, opts \\ []) do
    opts = Keyword.merge(@default_options, opts)

    with {:ok, response} <- make_request(conn, url, opts),
         {:ok, filename} <- extract_filename(response, opts[:filename]),
         {:ok, content_type} <- extract_content_type(response),
         :ok <- validate_response(response, opts) do
      case opts[:strategy] do
        :memory -> {:ok, {response.body, filename, content_type}}
        :temp -> save_to_temp_file(response.body, filename, opts)
        :file -> save_to_file(response.body, opts[:filename] || filename, opts)
        :stream -> {:error, :strategy_not_implemented}
      end
    end
  end

  @doc """
  Downloads a file to a temporary location.

  Returns `{:ok, filepath}` on success, where filepath is the path to the
  temporary file. The caller is responsible for cleaning up the temporary file.

  ## Examples

      {:ok, temp_path} = DocuSign.FileDownloader.download_to_temp(conn, url)
      content = File.read!(temp_path)
      File.rm!(temp_path)  # Clean up

  """
  @spec download_to_temp(DocuSign.Connection.t(), String.t(), keyword()) ::
          {:ok, String.t()} | {:error, term()}
  def download_to_temp(conn, url, opts \\ []) do
    download(conn, url, Keyword.put(opts, :strategy, :temp))
  end

  @doc """
  Downloads a file to memory.

  Returns `{:ok, {content, filename, content_type}}` on success.

  ## Examples

      {:ok, {pdf_content, "document.pdf", "application/pdf"}} =
        DocuSign.FileDownloader.download_to_memory(conn, url)

  """
  @spec download_to_memory(DocuSign.Connection.t(), String.t(), keyword()) ::
          {:ok, {binary(), String.t(), String.t()}} | {:error, term()}
  def download_to_memory(conn, url, opts \\ []) do
    download(conn, url, Keyword.put(opts, :strategy, :memory))
  end

  @doc """
  Downloads a file to a specific path.

  Returns `{:ok, filepath}` on success.

  ## Examples

      {:ok, path} = DocuSign.FileDownloader.download_to_file(conn, url, "/path/to/save/document.pdf")

  """
  @spec download_to_file(DocuSign.Connection.t(), String.t(), String.t(), keyword()) ::
          {:ok, String.t()} | {:error, term()}
  def download_to_file(conn, url, filepath, opts \\ []) do
    opts =
      opts
      |> Keyword.put(:strategy, :file)
      |> Keyword.put(:filename, filepath)

    download(conn, url, opts)
  end

  @doc """
  Extracts filename from Content-Disposition header.

  ## Examples

      iex> DocuSign.FileDownloader.extract_filename_from_header("attachment; filename=document.pdf")
      {:ok, "document.pdf"}

      iex> DocuSign.FileDownloader.extract_filename_from_header("attachment; filename*=UTF-8''document%20name.pdf")
      {:ok, "document name.pdf"}

      iex> DocuSign.FileDownloader.extract_filename_from_header("attachment")
      {:error, :no_filename}

  """
  @spec extract_filename_from_header(String.t()) :: {:ok, String.t()} | {:error, :no_filename}
  def extract_filename_from_header(content_disposition) when is_binary(content_disposition) do
    cond do
      # RFC 6266 encoded filename (filename*=UTF-8''name.pdf)
      match = Regex.run(~r/filename\*=UTF-8''([^;]+)/i, content_disposition) ->
        [_, encoded_filename] = match
        filename = URI.decode(encoded_filename)
        {:ok, sanitize_filename(filename)}

      # Standard filename (filename="name.pdf" or filename=name.pdf)
      # Handle quoted filenames with spaces
      match = Regex.run(~r/filename=["']([^"']+)["']/i, content_disposition) ->
        [_, filename] = match
        {:ok, sanitize_filename(filename)}

      # Handle unquoted filenames (no spaces allowed)
      match = Regex.run(~r/filename=([^;\s]+)/i, content_disposition) ->
        [_, filename] = match
        {:ok, sanitize_filename(filename)}

      true ->
        {:error, :no_filename}
    end
  end

  @doc """
  Sanitizes a filename by removing invalid characters and path components.

  ## Examples

      iex> DocuSign.FileDownloader.sanitize_filename("../../malicious.pdf")
      "malicious.pdf"

      iex> DocuSign.FileDownloader.sanitize_filename("file<>:\"|?*.pdf")
      "file.pdf"

  """
  @spec sanitize_filename(String.t()) :: String.t()
  def sanitize_filename(filename) when is_binary(filename) do
    filename
    # Remove any path components
    |> Path.basename()
    # Remove invalid filename characters
    |> String.replace(~r/[<>:"|?*\\\/]/, "")
    |> String.trim()
    |> case do
      "" -> "download"
      sanitized -> sanitized
    end
  end

  @doc """
  Cleans up tracked temporary files.

  This function calls `Temp.cleanup/0` to remove all tracked temporary files.
  Useful for manual cleanup before process exit.

  ## Examples

      DocuSign.FileDownloader.cleanup_temp_files()

  """
  @spec cleanup_temp_files() :: :ok
  def cleanup_temp_files do
    Temp.cleanup()
  end

  @doc """
  Generates a unique filename by appending a number if the file already exists.

  ## Examples

      # If document.pdf exists, returns document_1.pdf
      # If document_1.pdf also exists, returns document_2.pdf, etc.
      DocuSign.FileDownloader.ensure_unique_filename("/path/to/document.pdf")

  """
  @spec ensure_unique_filename(String.t()) :: String.t()
  def ensure_unique_filename(filepath) do
    if File.exists?(filepath) do
      dir = Path.dirname(filepath)
      basename = Path.basename(filepath, Path.extname(filepath))
      ext = Path.extname(filepath)

      find_unique_name(dir, basename, ext, 1)
    else
      filepath
    end
  end

  # Private functions

  defp make_request(conn, url, opts) do
    request_opts = []

    request_opts =
      if opts[:max_size],
        do: Keyword.put(request_opts, :max_body_length, opts[:max_size]),
        else: request_opts

    case DocuSign.Connection.request(conn, Keyword.merge([method: :get, url: url], request_opts)) do
      {:ok, %Req.Response{status: status} = response} when status in 200..299 ->
        {:ok, response}

      {:ok, %Req.Response{body: body, status: status}} ->
        {:error, {:http_error, status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp extract_filename(response, custom_filename) do
    case custom_filename do
      nil ->
        extract_filename_from_response(response)

      filename when is_binary(filename) ->
        {:ok, sanitize_filename(filename)}
    end
  end

  defp extract_filename_from_response(response) do
    content_disposition = get_header(response.headers, "content-disposition")

    if content_disposition do
      case extract_filename_from_header(content_disposition) do
        {:ok, filename} -> {:ok, filename}
        {:error, :no_filename} -> {:ok, generate_default_filename(response)}
      end
    else
      {:ok, generate_default_filename(response)}
    end
  end

  defp extract_content_type(response) do
    content_type = get_header(response.headers, "content-type") || "application/octet-stream"
    # Extract just the media type, ignore charset and other parameters
    media_type = content_type |> String.split(";") |> List.first() |> String.trim()
    {:ok, media_type}
  end

  defp validate_response(response, opts) do
    with :ok <- validate_content_size(response, opts[:max_size]) do
      validate_content_type(response, opts[:validate_content_type])
    end
  end

  defp validate_content_size(response, max_size) when is_integer(max_size) do
    content_length = get_header(response.headers, "content-length")
    body_size = byte_size(response.body)

    actual_size =
      if content_length do
        String.to_integer(content_length)
      else
        body_size
      end

    if actual_size > max_size do
      {:error, {:file_too_large, actual_size, max_size}}
    else
      :ok
    end
  end

  defp validate_content_size(_response, _max_size), do: :ok

  defp validate_content_type(_response, false), do: :ok

  defp validate_content_type(response, true) do
    content_type = get_header(response.headers, "content-type")
    allowed_types = get_allowed_content_types()

    if content_type && allowed_types do
      media_type = content_type |> String.split(";") |> List.first() |> String.trim()

      if media_type in allowed_types do
        :ok
      else
        {:error, {:invalid_content_type, media_type}}
      end
    else
      # Skip validation if no content-type or no restrictions
      :ok
    end
  end

  defp save_to_temp_file(content, filename, opts) do
    # Ensure temp tracking is enabled if configured
    if get_config(:track_temp_files, true) do
      case Temp.track() do
        {:ok, _} -> :ok
        {:error, :already_tracking} -> :ok
      end
    end

    # Prepare temp options
    prefix = Path.basename(filename, Path.extname(filename))
    suffix = Path.extname(filename)

    temp_options = opts[:temp_options] || []

    temp_options =
      temp_options
      |> Keyword.put_new(:prefix, prefix)
      |> Keyword.put_new(:suffix, suffix)

    case Temp.open(temp_options, fn file ->
           IO.binwrite(file, content)
         end) do
      {:ok, temp_path} ->
        Logger.info("Downloaded file to temporary location: #{temp_path}")
        {:ok, temp_path}

      {:error, reason} ->
        {:error, {:temp_file_error, reason}}
    end
  end

  defp save_to_file(content, filepath, opts) do
    filepath =
      if opts[:overwrite] do
        filepath
      else
        ensure_unique_filename(filepath)
      end

    # Ensure directory exists
    dir = Path.dirname(filepath)

    case File.mkdir_p(dir) do
      :ok ->
        case File.write(filepath, content) do
          :ok ->
            Logger.info("Downloaded file to: #{filepath}")
            {:ok, filepath}

          {:error, reason} ->
            {:error, {:file_write_error, reason}}
        end

      {:error, reason} ->
        {:error, {:directory_create_error, reason}}
    end
  end

  defp generate_default_filename(response) do
    content_type = get_header(response.headers, "content-type") || "application/octet-stream"

    ext =
      case String.split(content_type, "/") do
        ["application", "pdf"] -> ".pdf"
        ["text", "html"] -> ".html"
        ["image", subtype] -> ".#{subtype}"
        ["application", "zip"] -> ".zip"
        ["application", "json"] -> ".json"
        ["text", "plain"] -> ".txt"
        _ -> ""
      end

    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    "docusign_download_#{timestamp}#{ext}"
  end

  defp find_unique_name(dir, basename, ext, counter) do
    new_name = "#{basename}_#{counter}#{ext}"
    new_path = Path.join(dir, new_name)

    if File.exists?(new_path) do
      find_unique_name(dir, basename, ext, counter + 1)
    else
      new_path
    end
  end

  defp get_header(headers, name) do
    value =
      Enum.find_value(headers, fn {key, value} ->
        if String.downcase(key) == String.downcase(name), do: value
      end)

    # Req headers are always lists, even for single values
    # Extract the first value if it's a list
    case value do
      [single_value | _] when is_binary(single_value) -> single_value
      nil -> nil
      other -> other
    end
  end

  defp get_config(key, default) do
    Application.get_env(:docusign, :file_downloader, [])
    |> Keyword.get(key, default)
  end

  defp get_allowed_content_types do
    get_config(:allowed_content_types, nil)
  end
end
