# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.BCCEmailArchive do
  @moduledoc """
  API calls for all endpoints tagged `BCCEmailArchive`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes a BCC email archive configuration.
  This method deletes a BCC email archive configuration from an account.  When you use this method, the status of the BCC email archive configuration switches to `closed` and the BCC email address is no longer used to archive DocuSign-generated email messages.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `bcc_email_archive_id` (String.t): The ID of the BCC email archive configuration.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec b_cc_email_archive_delete_bcc_email_archive(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def b_cc_email_archive_delete_bcc_email_archive(
        connection,
        account_id,
        bcc_email_archive_id,
        _opts \\ []
      ) do
    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/settings/bcc_email_archives/#{bcc_email_archive_id}")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets a BCC email archive configuration and its history.
  This method returns a specific BCC email archive configuration for an account, as well as the history of changes to the email address.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `bcc_email_archive_id` (String.t): The ID of the BCC email archive configuration.
  - `opts` (keyword): Optional parameters
    - `:count` (String.t): The maximum number of results to return.  Use `start_position` to specify the number of items to skip.
    - `:start_position` (String.t): The zero-based index of the result from which to start returning results.  Use with `count` to limit the number of results.  The default value is `0`.

  ### Returns

  - `{:ok, DocuSign.Model.BccEmailArchiveHistoryList.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec b_cc_email_archive_get_bcc_email_archive_history_list(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.BccEmailArchiveHistoryList.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def b_cc_email_archive_get_bcc_email_archive_history_list(
        connection,
        account_id,
        bcc_email_archive_id,
        opts \\ []
      ) do
    optional_params = %{
      :count => :query,
      :start_position => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/settings/bcc_email_archives/#{bcc_email_archive_id}")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.BccEmailArchiveHistoryList{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets the BCC email archive configurations for an account.
  This method retrieves all of the BCC email archive configurations associated with an account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:count` (String.t): The maximum number of results to return.  Use `start_position` to specify the number of results to skip.
    - `:start_position` (String.t): The zero-based index of the result from which to start returning results.  Use with `count` to limit the number of results.  The default value is `0`.

  ### Returns

  - `{:ok, DocuSign.Model.BccEmailArchiveList.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec b_cc_email_archive_get_bcc_email_archive_list(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.BccEmailArchiveList.t()}
          | {:error, Tesla.Env.t()}
  def b_cc_email_archive_get_bcc_email_archive_list(connection, account_id, opts \\ []) do
    optional_params = %{
      :count => :query,
      :start_position => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/settings/bcc_email_archives")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.BccEmailArchiveList{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Creates a BCC email archive configuration.
  This method creates a BCC email archive configuration for an account (adds a BCC email address to the account for archiving the emails that DocuSign generates).  The only property that you must set in the request body is the BCC email address that you want to use.  **Note:** An account can have up to five active and pending email archive addresses combined, but you must use this method to add them to the account one at a time. Each email address is considered a separate BCC email archive configuration.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (BccEmailArchive): Boolean that specifies whether BCC for Email Archive is enabled for the account. BCC for Email Archive allows you to set up an archive email address so that a BCC copy of an envelope is sent only to that address.

  ### Returns

  - `{:ok, DocuSign.Model.BccEmailArchive.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec b_cc_email_archive_post_bcc_email_archive(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.BccEmailArchive.t()}
          | {:error, Tesla.Env.t()}
  def b_cc_email_archive_post_bcc_email_archive(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/settings/bcc_email_archives")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, %DocuSign.Model.BccEmailArchive{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end
