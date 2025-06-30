defmodule DocuSign.Error do
  @moduledoc """
  Defines structured errors for the DocuSign API client.
  """

  defexception message: nil, status: nil, body: nil, type: nil

  @type t :: %__MODULE__{
          body: map() | String.t() | nil,
          message: String.t() | nil,
          status: integer() | nil,
          type: atom() | nil
        }

  def new(env) do
    error_type =
      case env.status do
        400 -> DocuSign.ValidationError
        401 -> DocuSign.AuthenticationError
        429 -> DocuSign.RateLimitError
        _ -> DocuSign.ApiError
      end

    message =
      if is_map(env.body) and Map.has_key?(env.body, "message") do
        env.body["message"]
      else
        "DocuSign API Error"
      end

    struct!(error_type,
      message: message,
      status: env.status,
      body: env.body
    )
  end
end

defmodule DocuSign.ApiError do
  @moduledoc """
  Generic API error.
  """
  defexception [:message, :status, :body]
end

defmodule DocuSign.AuthenticationError do
  @moduledoc """
  Authentication error (401).
  """
  defexception [:message, :status, :body]
end

defmodule DocuSign.RateLimitError do
  @moduledoc """
  Rate limit exceeded error (429).
  """
  defexception [:message, :status, :body]
end

defmodule DocuSign.ValidationError do
  @moduledoc """
  Validation error (400).
  """
  defexception [:message, :status, :body]
end

defmodule DocuSign.NetworkError do
  @moduledoc """
  Network-related error.
  """
  defexception [:message, :reason]
end
