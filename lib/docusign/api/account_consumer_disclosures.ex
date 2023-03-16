# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.AccountConsumerDisclosures do
  @moduledoc """
  API calls for all endpoints tagged `AccountConsumerDisclosures`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Gets the default Electronic Record and Signature Disclosure for an account.
  Retrieves the default, HTML-formatted Electronic Record and Signature Disclosure (ERSD) associated with the account.   This is the default ERSD disclosure that DocuSign provides for the convenience of U.S.-based customers only. This default disclosure is only valid for transactions between U.S.-based parties.  To set the language of the disclosure that you want to retrieve, use the optional `langCode` query parameter.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:langCode` (String.t): The code for the signer language version of the disclosure that you want to retrieve. The following languages are supported:  - Arabic (`ar`) - Bulgarian (`bg`) - Czech (`cs`) - Chinese Simplified (`zh_CN`) - Chinese Traditional (`zh_TW`) - Croatian (`hr`) - Danish (`da`) - Dutch (`nl`) - English US (`en`) - English UK (`en_GB`) - Estonian (`et`) - Farsi (`fa`) - Finnish (`fi`) - French (`fr`) - French Canadian (`fr_CA`) - German (`de`) - Greek (`el`) - Hebrew (`he`) - Hindi (`hi`) - Hungarian (`hu`) - Bahasa Indonesian (`id`) - Italian (`it`) - Japanese (`ja`) - Korean (`ko`) - Latvian (`lv`) - Lithuanian (`lt`) - Bahasa Melayu (`ms`) - Norwegian (`no`) - Polish (`pl`) - Portuguese (`pt`) - Portuguese Brazil (`pt_BR`) - Romanian (`ro`) - Russian (`ru`) - Serbian (`sr`) - Slovak (`sk`) - Slovenian (`sl`) - Spanish (`es`) - Spanish Latin America (`es_MX`) - Swedish (`sv`) - Thai (`th`) - Turkish (`tr`) - Ukrainian (`uk`) - Vietnamese (`vi`)  Additionally, you can automatically detect the browser language being used by the viewer and display the disclosure in that language by setting the value to `browser`.

  ### Returns

  - `{:ok, DocuSign.Model.AccountConsumerDisclosures.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec consumer_disclosure_get_consumer_disclosure(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.AccountConsumerDisclosures.t()}
          | {:error, Tesla.Env.t()}
  def consumer_disclosure_get_consumer_disclosure(connection, account_id, opts \\ []) do
    optional_params = %{
      :langCode => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/consumer_disclosure")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.AccountConsumerDisclosures{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets the Electronic Record and Signature Disclosure for an account.
  Retrieves the HTML-formatted Electronic Record and Signature Disclosure (ERSD) associated with the account.   To set the language of the disclosure that you want to retrieve, use the optional `langCode` query parameter.  **Note:** The text of the default disclosure is always in English, but if you are using a custom disclosure and have created versions of it in different signer languages, you can use the `langCode` parameter to specify the signer language version that you want to retrieve.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `lang_code` (String.t): The code for the signer language version of the disclosure that you want to retrieve. The following languages are supported:  - Arabic (`ar`) - Bulgarian (`bg`) - Czech (`cs`) - Chinese Simplified (`zh_CN`) - Chinese Traditional (`zh_TW`) - Croatian (`hr`) - Danish (`da`) - Dutch (`nl`) - English US (`en`) - English UK (`en_GB`) - Estonian (`et`) - Farsi (`fa`) - Finnish (`fi`) - French (`fr`) - French Canadian (`fr_CA`) - German (`de`) - Greek (`el`) - Hebrew (`he`) - Hindi (`hi`) - Hungarian (`hu`) - Bahasa Indonesian (`id`) - Italian (`it`) - Japanese (`ja`) - Korean (`ko`) - Latvian (`lv`) - Lithuanian (`lt`) - Bahasa Melayu (`ms`) - Norwegian (`no`) - Polish (`pl`) - Portuguese (`pt`) - Portuguese Brazil (`pt_BR`) - Romanian (`ro`) - Russian (`ru`) - Serbian (`sr`) - Slovak (`sk`) - Slovenian (`sl`) - Spanish (`es`) - Spanish Latin America (`es_MX`) - Swedish (`sv`) - Thai (`th`) - Turkish (`tr`) - Ukrainian (`uk`) - Vietnamese (`vi`)  Additionally, you can automatically detect the browser language being used by the viewer and display the disclosure in that language by setting the value to `browser`.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.AccountConsumerDisclosures.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec consumer_disclosure_get_consumer_disclosure_lang_code(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.AccountConsumerDisclosures.t()}
          | {:error, Tesla.Env.t()}
  def consumer_disclosure_get_consumer_disclosure_lang_code(
        connection,
        account_id,
        lang_code,
        _opts \\ []
      ) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/consumer_disclosure/#{lang_code}")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.AccountConsumerDisclosures{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates the Electronic Record and Signature Disclosure for an account.
  Account administrators can use this method to perform the following tasks:  - Customize values in the default disclosure. - Switch to a custom disclosure that uses your own text and HTML formatting. - Change values in your existing consumer disclosure.   To specify the signer language version of the disclosure that you are updating, use the optional `langCode` query parameter.  **Note:** Only account administrators can use this method. Each time you change the disclosure content, all unsigned recipients of outstanding documents will be required to accept a new version.   ## Updating the default disclosure  When you update the default disclosure, you can edit all properties except for the following ones:  - `accountEsignId`: This property is read-only. - `custom`: The default value is **false.** Editing this property causes the default disclosure to switch to a custom disclosure. - `esignAgreement`: This property is read-only. - `esignText`: You cannot edit this property when `custom` is set to **false.** The API returns a 200 OK HTTP response, but does not update the `esignText`. - Metadata properties: These properties are read-only.  **Note:** The text of the default disclosure is always in English.  ## Switching to a custom disclosure  To switch to a custom disclosure, set the `custom` property to **true** and customize the value for the `eSignText` property.   You can also edit all of the other properties except for the following ones:  - `accountEsignId`: This property is read-only. - `esignAgreement`: This property is read-only. - Metadata properties: These properties are read-only.  **Note:** When you use a custom disclosure, you can create versions of it in different signer languages and se the `langCode` parameter to specify the signer language version that you are updating.  **Important:**  When you switch from a default to a custom disclosure, note the following information:  - You will not be able to return to using the default disclosure. - Only the disclosure for the currently selected signer language is saved. DocuSign will not automatically translate your custom disclosure. You must create a disclosure for each language that your signers use.  ## Updating a custom disclosure  When you update a custom disclosure, you can update all of the properties except for the following ones:  - `accountEsignId`: This property is read-only.  - `esignAgreement`: This property is read-only. - Metadata properties: These properties are read-only.  **Important:** Only the disclosure for the currently selected signer language is saved. DocuSign will not automatically translate your custom disclosure. You must create a disclosure for each language that your signers use.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `lang_code` (String.t): The code for the signer language version of the disclosure that you want to update. The following languages are supported:  - Arabic (`ar`) - Bulgarian (`bg`) - Czech (`cs`) - Chinese Simplified (`zh_CN`) - Chinese Traditional (`zh_TW`) - Croatian (`hr`) - Danish (`da`) - Dutch (`nl`) - English US (`en`) - English UK (`en_GB`) - Estonian (`et`) - Farsi (`fa`) - Finnish (`fi`) - French (`fr`) - French Canadian (`fr_CA`) - German (`de`) - Greek (`el`) - Hebrew (`he`) - Hindi (`hi`) - Hungarian (`hu`) - Bahasa Indonesian (`id`) - Italian (`it`) - Japanese (`ja`) - Korean (`ko`) - Latvian (`lv`) - Lithuanian (`lt`) - Bahasa Melayu (`ms`) - Norwegian (`no`) - Polish (`pl`) - Portuguese (`pt`) - Portuguese Brazil (`pt_BR`) - Romanian (`ro`) - Russian (`ru`) - Serbian (`sr`) - Slovak (`sk`) - Slovenian (`sl`) - Spanish (`es`) - Spanish Latin America (`es_MX`) - Swedish (`sv`) - Thai (`th`) - Turkish (`tr`) - Ukrainian (`uk`) - Vietnamese (`vi`)  Additionally, you can automatically detect the browser language being used by the viewer and display the disclosure in that language by setting the value to `browser`.
  - `opts` (keyword): Optional parameters
    - `:include_metadata` (String.t): (Optional) When true, the response includes metadata indicating which properties are editable.
    - `:body` (ConsumerDisclosure):

  ### Returns

  - `{:ok, DocuSign.Model.ConsumerDisclosure.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec consumer_disclosure_put_consumer_disclosure(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.ConsumerDisclosure.t()}
          | {:error, Tesla.Env.t()}
  def consumer_disclosure_put_consumer_disclosure(connection, account_id, lang_code, opts \\ []) do
    optional_params = %{
      :include_metadata => :query,
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/consumer_disclosure/#{lang_code}")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.ConsumerDisclosure{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end
