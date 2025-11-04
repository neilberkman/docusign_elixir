defmodule DocuSign.CustomHeadersIntegrationTest do
  use ExUnit.Case, async: false

  alias DocuSign.Api.EnvelopeLocks
  alias DocuSign.OAuth.Fake

  setup do
    bypass = Bypass.open()

    # Store original config for cleanup
    original_hostname = Application.get_env(:docusign, :hostname)
    original_client_id = Application.get_env(:docusign, :client_id)
    original_user_id = Application.get_env(:docusign, :user_id)
    original_private_key_file = Application.get_env(:docusign, :private_key_file)
    original_oauth_implementation = Application.get_env(:docusign, :oauth_implementation)

    # Configure the app to use our test server
    Application.put_env(:docusign, :hostname, "localhost:#{bypass.port}")
    Application.put_env(:docusign, :client_id, "test_client_id")
    Application.put_env(:docusign, :user_id, "test_user_id")
    Application.put_env(:docusign, :private_key_file, "test/support/test_key")
    Application.put_env(:docusign, :oauth_implementation, Fake)

    # Start ClientRegistry if not already running with Fake implementation
    case Process.whereis(DocuSign.ClientRegistry) do
      nil ->
        {:ok, _} = DocuSign.ClientRegistry.start_link(oauth_impl: Fake)

      pid ->
        # Stop existing registry and start with Fake implementation
        Process.exit(pid, :kill)
        {:ok, _} = DocuSign.ClientRegistry.start_link(oauth_impl: Fake)
    end

    # Add cleanup function
    on_exit(fn ->
      # Restore original config
      if original_hostname do
        Application.put_env(:docusign, :hostname, original_hostname)
      else
        Application.delete_env(:docusign, :hostname)
      end

      if original_client_id do
        Application.put_env(:docusign, :client_id, original_client_id)
      else
        Application.delete_env(:docusign, :client_id)
      end

      if original_user_id do
        Application.put_env(:docusign, :user_id, original_user_id)
      else
        Application.delete_env(:docusign, :user_id)
      end

      if original_private_key_file do
        Application.put_env(:docusign, :private_key_file, original_private_key_file)
      else
        Application.delete_env(:docusign, :private_key_file)
      end

      if original_oauth_implementation do
        Application.put_env(:docusign, :oauth_implementation, original_oauth_implementation)
      else
        Application.delete_env(:docusign, :oauth_implementation)
      end
    end)

    {:ok, bypass: bypass}
  end

  describe "custom headers support" do
    test "X-DocuSign-Edit header is sent in PUT requests for locked envelopes", %{
      bypass: bypass
    } do
      # Setup - Get connection
      {:ok, conn} = DocuSign.Connection.get("test_user_id")

      account_id = "17035828"
      envelope_id = "test-envelope-123"
      lock_token = "abc123-lock-token"
      lock_duration = "600"

      lock_edit_header =
        Jason.encode!(%{
          "LockDurationInSeconds" => lock_duration,
          "LockToken" => lock_token
        })

      # Mock the envelope lock update endpoint
      Bypass.expect_once(
        bypass,
        "PUT",
        "/restapi/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/lock",
        fn conn ->
          # CRITICAL: Verify the X-DocuSign-Edit header was sent!
          headers = Map.new(conn.req_headers)

          assert headers["x-docusign-edit"] == lock_edit_header,
                 "Expected X-DocuSign-Edit header to be present with lock token"

          # Read and verify body
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          request_body = Jason.decode!(body)

          # Verify request structure
          assert request_body["lockDurationInSeconds"]

          # Return success response
          response = %{
            "lockDurationInSeconds" => lock_duration,
            "lockToken" => lock_token,
            "lockedByUser" => %{
              "email" => "test@example.com",
              "userName" => "Test User"
            }
          }

          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.resp(200, Jason.encode!(response))
        end
      )

      # Act - Call the API with custom headers
      lock_request_body = %{
        "lockDurationInSeconds" => lock_duration
      }

      result =
        EnvelopeLocks.lock_put_envelope_lock(
          conn,
          account_id,
          envelope_id,
          body: lock_request_body,
          headers: %{"X-DocuSign-Edit" => lock_edit_header}
        )

      # Assert - Verify success
      assert {:ok, lock_info} = result
      assert lock_info.lockToken == lock_token
      assert lock_info.lockDurationInSeconds == lock_duration
    end

    test "multiple custom headers are sent correctly", %{bypass: bypass} do
      {:ok, conn} = DocuSign.Connection.get("test_user_id")

      account_id = "17035828"
      envelope_id = "test-envelope-456"

      custom_header_1_value = "custom-value-1"
      custom_header_2_value = "custom-value-2"

      # Mock endpoint that expects multiple custom headers
      Bypass.expect_once(
        bypass,
        "PUT",
        "/restapi/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/lock",
        fn conn ->
          headers = Map.new(conn.req_headers)

          # Verify both custom headers are present
          assert headers["x-custom-header-1"] == custom_header_1_value
          assert headers["x-custom-header-2"] == custom_header_2_value

          {:ok, body, conn} = Plug.Conn.read_body(conn)
          Jason.decode!(body)

          response = %{
            "lockDurationInSeconds" => "300",
            "lockToken" => "token123"
          }

          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.resp(200, Jason.encode!(response))
        end
      )

      # Call with multiple custom headers
      result =
        EnvelopeLocks.lock_put_envelope_lock(
          conn,
          account_id,
          envelope_id,
          body: %{"lockDurationInSeconds" => "300"},
          headers: %{
            "X-Custom-Header-1" => custom_header_1_value,
            "X-Custom-Header-2" => custom_header_2_value
          }
        )

      assert {:ok, _lock_info} = result
    end

    test "custom headers work with POST requests", %{bypass: bypass} do
      {:ok, conn} = DocuSign.Connection.get("test_user_id")

      account_id = "17035828"
      envelope_id = "test-envelope-789"

      custom_header_value = "post-custom-value"

      # Mock the envelope lock creation endpoint
      Bypass.expect_once(
        bypass,
        "POST",
        "/restapi/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/lock",
        fn conn ->
          headers = Map.new(conn.req_headers)

          # Verify custom header is present
          assert headers["x-custom-header"] == custom_header_value

          {:ok, body, conn} = Plug.Conn.read_body(conn)
          Jason.decode!(body)

          response = %{
            "lockDurationInSeconds" => "600",
            "lockToken" => "new-lock-token"
          }

          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.resp(201, Jason.encode!(response))
        end
      )

      # Call POST endpoint with custom headers
      result =
        EnvelopeLocks.lock_post_envelope_lock(
          conn,
          account_id,
          envelope_id,
          body: %{"lockDurationInSeconds" => "600"},
          headers: %{"X-Custom-Header" => custom_header_value}
        )

      assert {:ok, lock_info} = result
      assert lock_info.lockToken == "new-lock-token"
    end
  end
end
