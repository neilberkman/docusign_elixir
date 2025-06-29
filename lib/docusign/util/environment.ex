defmodule DocuSign.Util.Environment do
  @moduledoc """
  Utilities for automatic environment detection based on DocuSign URLs.

  This module provides functions to automatically determine whether to use
  sandbox or production OAuth endpoints based on the API base URL patterns,
  similar to the Ruby DocuSign client's environment detection logic.

  ## Environment Detection Rules

  The environment is detected based on URL patterns:
  - **Sandbox/Demo**: URLs containing "demo", "apps-d", or pointing to demo environments
  - **Production**: All other URLs default to production environment

  ## Examples

      iex> DocuSign.Util.Environment.determine_hostname("https://demo.docusign.net/restapi")
      "account-d.docusign.com"

      iex> DocuSign.Util.Environment.determine_hostname("https://na3.docusign.net/restapi")
      "account.docusign.com"

      iex> DocuSign.Util.Environment.detect_environment("https://demo.docusign.net")
      :sandbox

      iex> DocuSign.Util.Environment.detect_environment("https://na3.docusign.net")
      :production

  """

  @doc """
  Automatically determines the appropriate OAuth hostname based on the API base URI.

  This function analyzes the provided base URI and returns the corresponding
  OAuth hostname that should be used for authentication endpoints.

  ## Parameters

  - `base_uri` - The DocuSign API base URI (e.g., "https://demo.docusign.net/restapi")

  ## Returns

  - `"account-d.docusign.com"` for sandbox/demo environments
  - `"account.docusign.com"` for production environments

  ## Examples

      # Sandbox detection
      iex> DocuSign.Util.Environment.determine_hostname("https://demo.docusign.net/restapi")
      "account-d.docusign.com"

      iex> DocuSign.Util.Environment.determine_hostname("https://apps-d.docusign.com")
      "account-d.docusign.com"

      # Production detection
      iex> DocuSign.Util.Environment.determine_hostname("https://na3.docusign.net/restapi")
      "account.docusign.com"

      iex> DocuSign.Util.Environment.determine_hostname("https://eu.docusign.net/restapi")
      "account.docusign.com"

  """
  @spec determine_hostname(String.t()) :: String.t()
  def determine_hostname(base_uri) when is_binary(base_uri) do
    if sandbox_environment?(base_uri) do
      "account-d.docusign.com"
    else
      "account.docusign.com"
    end
  end

  @doc """
  Detects the environment type based on the API base URI.

  ## Parameters

  - `base_uri` - The DocuSign API base URI

  ## Returns

  - `:sandbox` for sandbox/demo environments
  - `:production` for production environments

  ## Examples

      iex> DocuSign.Util.Environment.detect_environment("https://demo.docusign.net")
      :sandbox

      iex> DocuSign.Util.Environment.detect_environment("https://na3.docusign.net")
      :production

  """
  @spec detect_environment(String.t()) :: :sandbox | :production
  def detect_environment(base_uri) when is_binary(base_uri) do
    if sandbox_environment?(base_uri) do
      :sandbox
    else
      :production
    end
  end

  @doc """
  Checks if the given URI indicates a sandbox/demo environment.

  This function implements the same detection logic as the DocuSign Ruby client,
  checking for URL patterns that indicate sandbox usage.

  ## Parameters

  - `uri` - The URI to check

  ## Returns

  - `true` if the URI indicates a sandbox environment
  - `false` if the URI indicates a production environment

  ## Examples

      iex> DocuSign.Util.Environment.sandbox_environment?("https://demo.docusign.net")
      true

      iex> DocuSign.Util.Environment.sandbox_environment?("https://apps-d.docusign.com")
      true

      iex> DocuSign.Util.Environment.sandbox_environment?("https://na3.docusign.net")
      false

  """
  @spec sandbox_environment?(String.t()) :: boolean()
  def sandbox_environment?(uri) when is_binary(uri) do
    # Implement the exact same logic as the Ruby DocuSign client
    # Check if base_path starts with sandbox patterns
    String.starts_with?(uri, ["https://demo", "http://demo", "https://apps-d", "http://apps-d"])
  end

  @doc """
  Gets the appropriate OAuth configuration based on environment detection.

  This function provides a convenient way to get complete OAuth configuration
  including hostname and other environment-specific settings.

  ## Parameters

  - `base_uri` - The DocuSign API base URI
  - `opts` - Optional keyword list with additional configuration

  ## Options

  - `:client_id` - OAuth client ID (integration key)
  - `:client_secret` - OAuth client secret

  ## Returns

  A keyword list with OAuth configuration:
  - `:hostname` - The OAuth hostname
  - `:environment` - `:sandbox` or `:production`
  - Plus any additional options passed in

  ## Examples

      iex> DocuSign.Util.Environment.oauth_config("https://demo.docusign.net", client_id: "abc123")
      [hostname: "account-d.docusign.com", environment: :sandbox, client_id: "abc123"]

  """
  @spec oauth_config(String.t(), Keyword.t()) :: Keyword.t()
  def oauth_config(base_uri, opts \\ []) when is_binary(base_uri) and is_list(opts) do
    hostname = determine_hostname(base_uri)
    environment = detect_environment(base_uri)

    [
      hostname: hostname,
      environment: environment
    ] ++ opts
  end

  @doc """
  Validates that the hostname matches the detected environment.

  This function can be used to verify that manually configured hostnames
  are consistent with the auto-detected environment.

  ## Parameters

  - `base_uri` - The DocuSign API base URI
  - `hostname` - The manually configured hostname

  ## Returns

  - `{:ok, hostname}` if the hostname matches the detected environment
  - `{:error, reason}` if there's a mismatch

  ## Examples

      iex> DocuSign.Util.Environment.validate_hostname("https://demo.docusign.net", "account-d.docusign.com")
      {:ok, "account-d.docusign.com"}

      iex> DocuSign.Util.Environment.validate_hostname("https://demo.docusign.net", "account.docusign.com")
      {:error, :environment_mismatch}

  """
  @spec validate_hostname(String.t(), String.t()) :: {:ok, String.t()} | {:error, atom()}
  def validate_hostname(base_uri, hostname) when is_binary(base_uri) and is_binary(hostname) do
    expected_hostname = determine_hostname(base_uri)

    if hostname == expected_hostname do
      {:ok, hostname}
    else
      {:error, :environment_mismatch}
    end
  end
end
