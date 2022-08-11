# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule DocuSign.Api.AccountSignatures do
  @moduledoc """
  API calls for all endpoints tagged `AccountSignatures`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder


  @doc """
  Close the specified signature by ID.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - signature_id (String.t): The ID of the signature being accessed.
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, nil} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec account_signatures_delete_account_signature(Tesla.Env.client, String.t, String.t, keyword()) :: {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t} | {:error, Tesla.Env.t}
  def account_signatures_delete_account_signature(connection, account_id, signature_id, _opts \\ []) do
    %{}
    |> method(:delete)
    |> url("/v2.1/accounts/#{account_id}/signatures/#{signature_id}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 200, false},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Deletes a signature image, initials, or stamp.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - image_type (String.t): Specificies the type of image. Valid values are:  - `signature_image` - `initials_image`
  - signature_id (String.t): The ID of the signature being accessed.
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, DocuSign.Model.AccountSignature.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec account_signatures_delete_account_signature_image(Tesla.Env.client, String.t, String.t, String.t, keyword()) :: {:ok, DocuSign.Model.ErrorDetails.t} | {:ok, DocuSign.Model.AccountSignature.t} | {:error, Tesla.Env.t}
  def account_signatures_delete_account_signature_image(connection, account_id, image_type, signature_id, _opts \\ []) do
    %{}
    |> method(:delete)
    |> url("/v2.1/accounts/#{account_id}/signatures/#{signature_id}/#{image_type}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 200, %DocuSign.Model.AccountSignature{}},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Returns information about the specified signature.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - signature_id (String.t): The ID of the signature being accessed.
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, DocuSign.Model.AccountSignature.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec account_signatures_get_account_signature(Tesla.Env.client, String.t, String.t, keyword()) :: {:ok, DocuSign.Model.ErrorDetails.t} | {:ok, DocuSign.Model.AccountSignature.t} | {:error, Tesla.Env.t}
  def account_signatures_get_account_signature(connection, account_id, signature_id, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/v2.1/accounts/#{account_id}/signatures/#{signature_id}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 200, %DocuSign.Model.AccountSignature{}},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Returns a signature image, initials, or stamp.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - image_type (String.t): Specificies the type of image. Valid values are:  - `signature_image` - `initials_image`
  - signature_id (String.t): The ID of the signature being accessed.
  - opts (KeywordList): [optional] Optional parameters
    - :include_chrome (String.t): When **true,** the chrome (or frame containing the added line and identifier) is included with the signature image.
  ## Returns

  {:ok, String.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec account_signatures_get_account_signature_image(Tesla.Env.client, String.t, String.t, String.t, keyword()) :: {:ok, DocuSign.Model.ErrorDetails.t} | {:ok, String.t} | {:error, Tesla.Env.t}
  def account_signatures_get_account_signature_image(connection, account_id, image_type, signature_id, opts \\ []) do
    optional_params = %{
      :include_chrome => :query
    }
    %{}
    |> method(:get)
    |> url("/v2.1/accounts/#{account_id}/signatures/#{signature_id}/#{image_type}")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 200, false},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Returns the managed signature definitions for the account

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - opts (KeywordList): [optional] Optional parameters
    - :stamp_format (String.t): 
    - :stamp_name (String.t): 
    - :stamp_type (String.t): 
  ## Returns

  {:ok, DocuSign.Model.AccountSignaturesInformation.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec account_signatures_get_account_signatures(Tesla.Env.client, String.t, keyword()) :: {:ok, DocuSign.Model.ErrorDetails.t} | {:ok, DocuSign.Model.AccountSignaturesInformation.t} | {:error, Tesla.Env.t}
  def account_signatures_get_account_signatures(connection, account_id, opts \\ []) do
    optional_params = %{
      :stamp_format => :query,
      :stamp_name => :query,
      :stamp_type => :query
    }
    %{}
    |> method(:get)
    |> url("/v2.1/accounts/#{account_id}/signatures")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 200, %DocuSign.Model.AccountSignaturesInformation{}},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Adds or updates one or more account signatures. This request may include images in multi-part format.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - opts (KeywordList): [optional] Optional parameters
    - :decode_only (String.t): 
    - :body (AccountSignaturesInformation): 
  ## Returns

  {:ok, DocuSign.Model.AccountSignaturesInformation.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec account_signatures_post_account_signatures(Tesla.Env.client, String.t, keyword()) :: {:ok, DocuSign.Model.ErrorDetails.t} | {:ok, DocuSign.Model.AccountSignaturesInformation.t} | {:error, Tesla.Env.t}
  def account_signatures_post_account_signatures(connection, account_id, opts \\ []) do
    optional_params = %{
      :decode_only => :query,
      :body => :body
    }
    %{}
    |> method(:post)
    |> url("/v2.1/accounts/#{account_id}/signatures")
    |> add_optional_params(optional_params, opts)
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 201, %DocuSign.Model.AccountSignaturesInformation{}},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates an account signature. 

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - opts (KeywordList): [optional] Optional parameters
    - :body (AccountSignaturesInformation): 
  ## Returns

  {:ok, DocuSign.Model.AccountSignaturesInformation.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec account_signatures_put_account_signature(Tesla.Env.client, String.t, keyword()) :: {:ok, DocuSign.Model.ErrorDetails.t} | {:ok, DocuSign.Model.AccountSignaturesInformation.t} | {:error, Tesla.Env.t}
  def account_signatures_put_account_signature(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }
    %{}
    |> method(:put)
    |> url("/v2.1/accounts/#{account_id}/signatures")
    |> add_optional_params(optional_params, opts)
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 200, %DocuSign.Model.AccountSignaturesInformation{}},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates an account signature.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - signature_id (String.t): The ID of the signature being accessed.
  - opts (KeywordList): [optional] Optional parameters
    - :close_existing_signature (String.t): When **true,** closes the current signature.
    - :body (AccountSignatureDefinition): 
  ## Returns

  {:ok, DocuSign.Model.AccountSignature.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec account_signatures_put_account_signature_by_id(Tesla.Env.client, String.t, String.t, keyword()) :: {:ok, DocuSign.Model.ErrorDetails.t} | {:ok, DocuSign.Model.AccountSignature.t} | {:error, Tesla.Env.t}
  def account_signatures_put_account_signature_by_id(connection, account_id, signature_id, opts \\ []) do
    optional_params = %{
      :close_existing_signature => :query,
      :body => :body
    }
    %{}
    |> method(:put)
    |> url("/v2.1/accounts/#{account_id}/signatures/#{signature_id}")
    |> add_optional_params(optional_params, opts)
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 200, %DocuSign.Model.AccountSignature{}},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Sets a signature image, initials, or stamp.

  ## Parameters

  - connection (DocuSign.Connection): Connection to server
  - account_id (String.t): The external account number (int) or account ID GUID.
  - image_type (String.t): Specificies the type of image. Valid values are:  - `signature_image` - `initials_image`
  - signature_id (String.t): The ID of the signature being accessed.
  - opts (KeywordList): [optional] Optional parameters
    - :transparent_png (String.t): 
  ## Returns

  {:ok, DocuSign.Model.AccountSignature.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec account_signatures_put_account_signature_image(Tesla.Env.client, String.t, String.t, String.t, keyword()) :: {:ok, DocuSign.Model.ErrorDetails.t} | {:ok, DocuSign.Model.AccountSignature.t} | {:error, Tesla.Env.t}
  def account_signatures_put_account_signature_image(connection, account_id, image_type, signature_id, opts \\ []) do
    optional_params = %{
      :transparent_png => :query
    }
    %{}
    |> method(:put)
    |> url("/v2.1/accounts/#{account_id}/signatures/#{signature_id}/#{image_type}")
    |> add_optional_params(optional_params, opts)
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      { 200, %DocuSign.Model.AccountSignature{}},
      { 400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end