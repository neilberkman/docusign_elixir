defmodule DocuSign.SDKVersionTest do
  use ExUnit.Case, async: true

  alias DocuSign.SDKVersion

  describe "version/0" do
    test "returns a valid semver version" do
      version = SDKVersion.version()
      assert version =~ ~r/^\d+\.\d+\.\d+$/
    end
  end

  describe "api_version/0" do
    test "returns the API version" do
      assert SDKVersion.api_version() == "v2.1"
    end
  end

  describe "user_agent/1" do
    test "generates proper user agent string" do
      user_agent = SDKVersion.user_agent()
      version = SDKVersion.version()

      # Check basic structure using the actual version
      expected_pattern =
        ~r/^docusign-elixir\/#{Regex.escape(version)} \(Elixir\/[\d\.]+; OTP\/[\d]+; API\/v2\.1\)$/

      assert user_agent =~ expected_pattern

      # Check it contains Elixir version
      assert user_agent =~ "Elixir/#{System.version()}"

      # Check it contains OTP version
      otp_version = :erlang.system_info(:otp_release) |> List.to_string()
      assert user_agent =~ "OTP/#{otp_version}"

      # Check it contains API version
      assert user_agent =~ "API/v2.1"
    end

    test "supports custom suffix" do
      user_agent = SDKVersion.user_agent(custom_suffix: "MyApp/1.0.0")
      version = SDKVersion.version()

      expected_pattern =
        ~r/^docusign-elixir\/#{Regex.escape(version)} \(Elixir\/[\d\.]+; OTP\/[\d]+; API\/v2\.1\) MyApp\/1\.0\.0$/

      assert user_agent =~ expected_pattern

      assert user_agent =~ " MyApp/1.0.0"
    end

    test "handles nil custom suffix" do
      user_agent = SDKVersion.user_agent(custom_suffix: nil)
      version = SDKVersion.version()

      refute user_agent =~ " nil"

      expected_pattern =
        ~r/^docusign-elixir\/#{Regex.escape(version)} \(Elixir\/[\d\.]+; OTP\/[\d]+; API\/v2\.1\)$/

      assert user_agent =~ expected_pattern
    end
  end

  describe "metadata/0" do
    test "returns complete metadata map" do
      metadata = SDKVersion.metadata()
      version = SDKVersion.version()

      assert metadata.sdk_name == "docusign-elixir"
      assert metadata.sdk_version == version
      assert metadata.api_version == "v2.1"
      assert metadata.elixir_version == System.version()

      otp_version = :erlang.system_info(:otp_release) |> List.to_string()
      assert metadata.otp_version == otp_version
    end

    test "metadata has all expected keys" do
      metadata = SDKVersion.metadata()

      expected_keys = [:sdk_name, :sdk_version, :api_version, :elixir_version, :otp_version]

      for key <- expected_keys do
        assert Map.has_key?(metadata, key), "Missing key: #{key}"
      end
    end
  end
end
