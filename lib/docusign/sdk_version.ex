defmodule DocuSign.SDKVersion do
  @moduledoc """
  SDK version information and User-Agent header management.

  This module provides version information about the DocuSign Elixir SDK
  and formats the User-Agent header for API requests.
  """

  @sdk_version "3.0.0"
  @api_version "v2.1"
  @sdk_name "docusign-elixir"

  @doc """
  Returns the SDK version.

  ## Examples

      iex> DocuSign.SDKVersion.version()
      "3.0.0"

  """
  @spec version() :: String.t()
  def version, do: @sdk_version

  @doc """
  Returns the API version this SDK targets.

  ## Examples

      iex> DocuSign.SDKVersion.api_version()
      "v2.1"

  """
  @spec api_version() :: String.t()
  def api_version, do: @api_version

  @doc """
  Generates the User-Agent string for HTTP requests.

  Includes SDK version, API version, and runtime information (Elixir and OTP versions).

  ## Options

    * `:custom_suffix` - Optional custom string to append to the User-Agent

  ## Examples

      iex> DocuSign.SDKVersion.user_agent()
      "docusign-elixir/3.0.0 (Elixir/1.16.0; OTP/26.0; API/v2.1)"

      iex> DocuSign.SDKVersion.user_agent(custom_suffix: "MyApp/1.0")
      "docusign-elixir/3.0.0 (Elixir/1.16.0; OTP/26.0; API/v2.1) MyApp/1.0"

  """
  @spec user_agent(keyword()) :: String.t()
  def user_agent(opts \\ []) do
    elixir_version = System.version()
    otp_version = :erlang.system_info(:otp_release) |> List.to_string()

    base_agent =
      "#{@sdk_name}/#{@sdk_version} (Elixir/#{elixir_version}; OTP/#{otp_version}; API/#{@api_version})"

    case Keyword.get(opts, :custom_suffix) do
      nil -> base_agent
      suffix -> "#{base_agent} #{suffix}"
    end
  end

  @doc """
  Returns a map of SDK metadata for telemetry and logging.

  ## Examples

      iex> DocuSign.SDKVersion.metadata()
      %{
        sdk_name: "docusign-elixir",
        sdk_version: "3.0.0",
        api_version: "v2.1",
        elixir_version: "1.16.0",
        otp_version: "26"
      }

  """
  @spec metadata() :: map()
  def metadata do
    %{
      api_version: @api_version,
      elixir_version: System.version(),
      otp_version: :erlang.system_info(:otp_release) |> List.to_string(),
      sdk_name: @sdk_name,
      sdk_version: @sdk_version
    }
  end
end
