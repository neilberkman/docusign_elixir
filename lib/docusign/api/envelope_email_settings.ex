# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.EnvelopeEmailSettings do
  @moduledoc """
  API calls for all endpoints tagged `EnvelopeEmailSettings`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes the email setting overrides for an envelope.
  Deletes all existing email override settings for the envelope. If you want to delete an individual email override setting, use the PUT and set the value to an empty string. Note that deleting email settings will only affect email communications that occur after the deletion and the normal account email settings are used for future email communications.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.EmailSettings.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec email_settings_delete_email_settings(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.EmailSettings.t()}
          | {:error, Tesla.Env.t()}
  def email_settings_delete_email_settings(connection, account_id, envelope_id, _opts \\ []) do
    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/email_settings")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EmailSettings},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Gets the email setting overrides for an envelope.
  Retrieves the email override settings for the specified envelope.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.EmailSettings.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec email_settings_get_email_settings(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.EmailSettings.t()}
          | {:error, Tesla.Env.t()}
  def email_settings_get_email_settings(connection, account_id, envelope_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/email_settings")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EmailSettings},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Adds email setting overrides to an envelope.
  Adds email override settings, changing the email address to reply to an email address, name, or the BCC for email archive information, for the envelope. Note that adding email settings will only affect email communications that occur after the addition was made.  The BCC Email address feature is designed to provide a copy of all email communications for external archiving purposes. To send a copy of the envelope to a recipient who does not need to sign, use a Carbon Copy or Certified Delivery recipient type.  **Note:** Docusign recommends that envelopes sent using the BCC for Email Archive feature, including the BCC Email Override option, include additional signer authentication options. 

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:body` (EmailSettings): A complex type that contains email settings.

  ### Returns

  - `{:ok, DocuSign.Model.EmailSettings.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec email_settings_post_email_settings(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.EmailSettings.t()}
          | {:error, Tesla.Env.t()}
  def email_settings_post_email_settings(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/email_settings")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, DocuSign.Model.EmailSettings},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end

  @doc """
  Updates the email setting overrides for an envelope.
  Updates the existing email override settings for the specified envelope. Note that modifying email settings will only affect email communications that occur after the modification was made.  This can also be used to delete an individual email override setting by using an empty string for the value to be deleted.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_id` (String.t): The envelope's GUID.   Example: `93be49ab-xxxx-xxxx-xxxx-f752070d71ec` 
  - `opts` (keyword): Optional parameters
    - `:body` (EmailSettings): A complex type that contains email settings.

  ### Returns

  - `{:ok, DocuSign.Model.EmailSettings.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec email_settings_put_email_settings(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.EmailSettings.t()}
          | {:error, Tesla.Env.t()}
  def email_settings_put_email_settings(connection, account_id, envelope_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/envelopes/#{envelope_id}/email_settings")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.EmailSettings},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end
end
