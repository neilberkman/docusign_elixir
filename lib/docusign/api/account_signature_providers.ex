# NOTE: This class is auto generated by the swagger code generator program.
# https://github.com/swagger-api/swagger-codegen.git
# Do not edit the class manually.

defmodule DocuSign.Api.AccountSignatureProviders do
  @moduledoc """
  API calls for all endpoints tagged `AccountSignatureProviders`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Returns Account available signature providers for specified account.


  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID Guid.
  - opts (KeywordList): [optional] Optional parameters

  ## Returns

  {:ok, %DocuSign.Model.AccountSignatureProviders{}} on success
  {:error, info} on failure
  """
  @spec account_signature_providers_get_signature_providers(
          Tesla.Env.client(),
          String.t(),
          keyword()
        ) :: {:ok, DocuSign.Model.AccountSignatureProviders.t()} | {:error, Tesla.Env.t()}
  def account_signature_providers_get_signature_providers(connection, account_id, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/v2/accounts/#{account_id}/signatureProviders")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> decode(%DocuSign.Model.AccountSignatureProviders{})
  end
end
