defmodule DocuSign.ErrorTest do
  use ExUnit.Case, async: true

  alias DocuSign.Error

  describe "Error struct creation" do
    test "creates ApiError for generic errors" do
      response = %Req.Response{body: %{"message" => "Server error"}, status: 500}
      error = Error.new(response)

      assert %DocuSign.ApiError{} = error
      assert error.status == 500
      assert error.message == "Server error"
    end

    test "creates AuthenticationError for 401" do
      response = %Req.Response{body: %{"message" => "Unauthorized"}, status: 401}
      error = Error.new(response)

      assert %DocuSign.AuthenticationError{} = error
      assert error.status == 401
      assert error.message == "Unauthorized"
    end

    test "creates RateLimitError for 429" do
      response = %Req.Response{body: %{"message" => "Rate limit exceeded"}, status: 429}
      error = Error.new(response)

      assert %DocuSign.RateLimitError{} = error
      assert error.status == 429
      assert error.message == "Rate limit exceeded"
    end

    test "creates ValidationError for 400" do
      response = %Req.Response{body: %{"message" => "Invalid request"}, status: 400}
      error = Error.new(response)

      assert %DocuSign.ValidationError{} = error
      assert error.status == 400
      assert error.message == "Invalid request"
    end
  end
end
