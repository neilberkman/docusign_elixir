#!/usr/bin/env elixir

# Script to capture REAL DocuSign API responses for testing
# This should have been done when credentials were provided!

Mix.install([
  {:docusign, path: ".", override: true},
  {:jason, "~> 1.4"},
  {:req, "~> 0.5"}
])

defmodule CaptureRealResponses do
  @moduledoc """
  Captures REAL DocuSign API responses to create proper integration tests.
  This ensures our tests catch real issues like header format differences.
  """

  alias DocuSign.Api.Envelopes

  def capture_envelope_document_download do
    client_id = System.get_env("DOCUSIGN_CLIENT_ID")
    user_id = System.get_env("DOCUSIGN_USER_ID")
    account_id = System.get_env("DOCUSIGN_ACCOUNT_ID")

    if client_id && user_id && account_id do
      capture_with_credentials(user_id, account_id)
    else
      print_credentials_error()
    end
  end

  defp capture_with_credentials(user_id, account_id) do
    IO.puts("Capturing real DocuSign API responses...")

    {:ok, conn} = DocuSign.Connection.get(user_id)

    case Envelopes.envelopes_get_envelopes(conn, account_id, from_date: "2024-01-01") do
      {:ok, response} ->
        handle_envelopes_response(conn, account_id, response)

      error ->
        IO.puts("Failed to get envelopes: #{inspect(error)}")
    end
  end

  defp handle_envelopes_response(conn, account_id, response) do
    IO.puts("Got envelopes response")
    save_response("envelopes_list", response)

    if response["envelopes"] && not Enum.empty?(response["envelopes"]) do
      envelope = hd(response["envelopes"])
      envelope_id = envelope["envelopeId"]
      download_document(conn, account_id, envelope_id)
    end
  end

  defp download_document(conn, account_id, envelope_id) do
    case Envelopes.envelopes_get_document(conn, account_id, envelope_id, "1") do
      {:ok, doc_response} ->
        IO.puts("Got document response - capturing headers!")
        save_response("document_download", doc_response)

      error ->
        IO.puts("Failed to get document: #{inspect(error)}")
    end
  end

  defp print_credentials_error do
    IO.puts("""
    ERROR: DocuSign credentials not found in environment!

    This script requires REAL DocuSign credentials to capture REAL API responses.
    Set these environment variables:
    - DOCUSIGN_CLIENT_ID
    - DOCUSIGN_USER_ID
    - DOCUSIGN_ACCOUNT_ID

    This should have been done when credentials were first provided to ensure
    tests use REAL response formats, not mocked ones that don't match reality!
    """)
  end

  defp save_response(name, response) do
    File.mkdir_p!("test/fixtures/real_responses")
    path = "test/fixtures/real_responses/#{name}.json"
    File.write!(path, Jason.encode!(response, pretty: true))
    IO.puts("Saved response to #{path}")
  end
end

# Run the capture
CaptureRealResponses.capture_envelope_document_download()
