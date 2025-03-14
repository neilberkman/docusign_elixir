# NOTE: This file is auto generated by OpenAPI Generator 7.12.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.AccountSignatureProviders do
  @moduledoc """
  API calls for all endpoints tagged `AccountSignatureProviders`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Gets the available signature providers for an account.
  Returns a list of signature providers that the specified account can use.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.AccountSignatureProviders.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec account_signature_providers_get_signature_providers(
          Tesla.Env.client(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.AccountSignatureProviders.t()}
          | {:error, Tesla.Env.t()}
  def account_signature_providers_get_signature_providers(connection, account_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/signatureProviders")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, DocuSign.Model.AccountSignatureProviders},
      {400, DocuSign.Model.ErrorDetails}
    ])
  end
end
