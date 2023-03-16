# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.IdentityVerifications do
  @moduledoc """
  API calls for all endpoints tagged `IdentityVerifications`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Retrieves the Identity Verification workflows available to an account.
  This method returns a list of Identity Verification workflows that are available to an account.  **Note:** To use this method, you must either be an account administrator or a sender.  ### Related topics  - [How to require ID Verification (IDV) for a recipient](/docs/esign-rest-api/how-to/id-verification/)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.AccountIdentityVerificationResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec account_identity_verification_get_account_identity_verification(
          Tesla.Env.client(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.AccountIdentityVerificationResponse.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def account_identity_verification_get_account_identity_verification(
        connection,
        account_id,
        _opts \\ []
      ) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/identity_verification")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.AccountIdentityVerificationResponse{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end
