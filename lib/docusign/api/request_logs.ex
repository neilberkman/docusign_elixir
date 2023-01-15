# NOTE: This file is auto generated by OpenAPI Generator 6.2.1 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.RequestLogs do
  @moduledoc """
  API calls for all endpoints tagged `RequestLogs`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes the request log files.
  Deletes the request log files.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec a_pi_request_log_delete_request_logs(Tesla.Env.client(), keyword()) ::
          {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def a_pi_request_log_delete_request_logs(connection, _opts \\ []) do
    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/diagnostics/request_logs")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets a request logging log file.
  Retrieves information for a single log entry.  **Request** The `requestLogId` property can be retrieved by getting the list of log entries. The Content-Transfer-Encoding header can be set to base64 to retrieve the API request/response as base 64 string. Otherwise the bytes of the request/response are returned.  **Response** If the Content-Transfer-Encoding header was set to base64, the log is returned as a base64 string.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `request_log_id` (String.t): The ID of the log entry.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, String.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec a_pi_request_log_get_request_log(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()} | {:ok, String.t()} | {:error, Tesla.Env.t()}
  def a_pi_request_log_get_request_log(connection, request_log_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/diagnostics/request_logs/#{request_log_id}")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets the API request logging settings.
  Retrieves the current API request logging setting for the user and remaining log entries.  **Response** The response includes the current API request logging setting for the user, along with the maximum log entries and remaining log entries.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.DiagnosticsSettingsInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec a_pi_request_log_get_request_log_settings(Tesla.Env.client(), keyword()) ::
          {:ok, DocuSign.Model.DiagnosticsSettingsInformation.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def a_pi_request_log_get_request_log_settings(connection, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/diagnostics/settings")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.DiagnosticsSettingsInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets the API request logging log files.
  Retrieves a list of log entries as a JSON or XML object or as a zip file containing the entries.  If the Accept header is set to `application/zip`, the response is a zip file containing individual text files, each representing an API request.  If the Accept header is set to `application/json` or `application/xml`, the response returns list of log entries in either JSON or XML. An example JSON response body is shown below. 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `opts` (keyword): Optional parameters
    - `:encoding` (String.t): Reserved for DocuSign.

  ### Returns

  - `{:ok, DocuSign.Model.ApiRequestLogsResult.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec a_pi_request_log_get_request_logs(Tesla.Env.client(), keyword()) ::
          {:ok, DocuSign.Model.ApiRequestLogsResult.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def a_pi_request_log_get_request_logs(connection, opts \\ []) do
    optional_params = %{
      :encoding => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/diagnostics/request_logs")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.ApiRequestLogsResult{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Enables or disables API request logging for troubleshooting.
  Enables or disables API request logging for troubleshooting.  When enabled (`apiRequestLogging` is **true**), REST API requests and responses for the user are added to a log. A log can have up to 50 requests/responses and the current number of log entries can be determined by getting the settings. Logging is automatically disabled when the log limit of 50 is reached.  You can call [Diagnostics: getRequestLog](/docs/esign-rest-api/reference/diagnostics/requestlogs/get/) or [Diagnostics: listRequestLogs](/docs/esign-rest-api/reference/diagnostics/requestlogs/list/) to download the log files (individually or as a zip file). Call [Diagnostics: deleteRequestLogs](/docs/esign-rest-api/reference/diagnostics/requestlogs/delete/) to clear the log by deleting current entries.  Private information, such as passwords and integration key information, which is normally located in the call header is omitted from the request/response log.  API request logging only captures requests from the authenticated user. Any call that does not authenticate the user and resolve a userId is not logged. 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `opts` (keyword): Optional parameters
    - `:body` (DiagnosticsSettingsInformation): 

  ### Returns

  - `{:ok, DocuSign.Model.DiagnosticsSettingsInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec a_pi_request_log_put_request_log_settings(Tesla.Env.client(), keyword()) ::
          {:ok, DocuSign.Model.DiagnosticsSettingsInformation.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def a_pi_request_log_put_request_log_settings(connection, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/diagnostics/settings")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.DiagnosticsSettingsInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end
