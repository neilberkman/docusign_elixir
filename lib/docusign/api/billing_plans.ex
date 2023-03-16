# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.BillingPlans do
  @moduledoc """
  API calls for all endpoints tagged `BillingPlans`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Get Account Billing Plan
  Retrieves the billing plan information for the specified account, including the current billing plan, successor plans, billing address, and billing credit card.  By default the successor plan and credit card information is included in the response. You can exclude this information from the response by adding the appropriate optional query string and setting it to **false.**  Response  The response returns the billing plan information, including the currency code, for the plan. The `billingPlan` and `succesorPlans` property values are the same as those shown in the [Billing: getBillingPlan](/docs/esign-rest-api/reference/billing/billingplans/get/) reference. the `billingAddress` and `creditCardInformation` property values are the same as those shown in the [Billing: updatePlan](/docs/esign-rest-api/reference/billing/billingplans/update/) reference.  **Note:** When credit card number information displays, a mask is applied to the response so that only the last 4 digits of the card number are visible.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:include_credit_card_information` (String.t): When **true,** payment information including credit card information will show in the return.
    - `:include_downgrade_information` (String.t):
    - `:include_metadata` (String.t): When **true,** the `canUpgrade` and `renewalStatus` properties are included the response and an array of `supportedCountries` is added to the `billingAddress` information.
    - `:include_successor_plans` (String.t): When **true,** excludes successor information from the response.
    - `:include_tax_exempt_id` (String.t):

  ### Returns

  - `{:ok, DocuSign.Model.AccountBillingPlanResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec billing_plan_get_billing_plan(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.AccountBillingPlanResponse.t()}
          | {:error, Tesla.Env.t()}
  def billing_plan_get_billing_plan(connection, account_id, opts \\ []) do
    optional_params = %{
      :include_credit_card_information => :query,
      :include_downgrade_information => :query,
      :include_metadata => :query,
      :include_successor_plans => :query,
      :include_tax_exempt_id => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/billing_plan")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.AccountBillingPlanResponse{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Get credit card information
  This method returns information about a credit card associated with an account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.CreditCardInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec billing_plan_get_credit_card_info(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.CreditCardInformation.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def billing_plan_get_credit_card_info(connection, account_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/billing_plan/credit_card")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.CreditCardInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Returns downgrade plan information for the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.DowngradRequestBillingInfoResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec billing_plan_get_downgrade_request_billing_info(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.DowngradRequestBillingInfoResponse.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def billing_plan_get_downgrade_request_billing_info(connection, account_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/billing_plan/downgrade")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.DowngradRequestBillingInfoResponse{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates an account billing plan.
  Updates the billing plan information, billing address, and credit card information for the specified account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:preview_billing_plan` (String.t): When **true,** updates the account using a preview billing plan.
    - `:body` (BillingPlanInformation):

  ### Returns

  - `{:ok, DocuSign.Model.BillingPlanUpdateResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec billing_plan_put_billing_plan(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.BillingPlanUpdateResponse.t()}
          | {:error, Tesla.Env.t()}
  def billing_plan_put_billing_plan(connection, account_id, opts \\ []) do
    optional_params = %{
      :preview_billing_plan => :query,
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/billing_plan")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.BillingPlanUpdateResponse{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Queues downgrade billing plan request for an account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (DowngradeBillingPlanInformation):

  ### Returns

  - `{:ok, DocuSign.Model.DowngradePlanUpdateResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec billing_plan_put_downgrade_account_billing_plan(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.DowngradePlanUpdateResponse.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def billing_plan_put_downgrade_account_billing_plan(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/billing_plan/downgrade")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.DowngradePlanUpdateResponse{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets billing plan details.
  Retrieves the billing plan details for the specified billing plan ID.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `billing_plan_id` (String.t): The ID of the billing plan being accessed.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.BillingPlanResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec billing_plans_get_billing_plan(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.BillingPlanResponse.t()}
          | {:error, Tesla.Env.t()}
  def billing_plans_get_billing_plan(connection, billing_plan_id, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/billing_plans/#{billing_plan_id}")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.BillingPlanResponse{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets a list of available billing plans.
  Retrieves a list of the billing plans associated with a distributor.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.BillingPlansResponse.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec billing_plans_get_billing_plans(Tesla.Env.client(), keyword()) ::
          {:ok, DocuSign.Model.BillingPlansResponse.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def billing_plans_get_billing_plans(connection, _opts \\ []) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/billing_plans")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.BillingPlansResponse{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Reserved: Purchase additional envelopes.
  Reserved: At this time, this endpoint is limited to DocuSign internal use only. Completes the purchase of envelopes for your account. The actual purchase is done as part of an internal workflow interaction with an envelope vendor.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (PurchasedEnvelopesInformation):

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec purchased_envelopes_put_purchased_envelopes(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def purchased_envelopes_put_purchased_envelopes(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/billing_plan/purchased_envelopes")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end
