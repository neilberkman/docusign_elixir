# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.EnvelopeTransferRules do
  @moduledoc """
  API calls for all endpoints tagged `EnvelopeTransferRules`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Deletes an envelope transfer rule.
  This method deletes an envelope transfer rule.  **Note:** Only Administrators can delete envelope transfer rules. In addition, to use envelope transfer rules, the **Transfer Custody** feature must be enabled for your account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_transfer_rule_id` (String.t): The ID of the envelope transfer rule. The system generates this ID when the rule is first created.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec envelope_transfer_rules_delete_envelope_transfer_rules(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def envelope_transfer_rules_delete_envelope_transfer_rules(
        connection,
        account_id,
        envelope_transfer_rule_id,
        _opts \\ []
      ) do
    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/envelopes/transfer_rules/#{envelope_transfer_rule_id}")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets envelope transfer rules.
  This method retrieves a list of envelope transfer rules associated with an account.  **Note:** Only Administrators can create and use envelope transfer rules. In addition, to use envelope transfer rules, the **Transfer Custody** feature must be enabled for your account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:count` (String.t): The maximum number of results to return.  Use `start_position` to specify the number of results to skip.
    - `:start_position` (String.t): The zero-based index of the result from which to start returning results.  Use with `count` to limit the number of results.  The default value is `0`.

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeTransferRuleInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec envelope_transfer_rules_get_envelope_transfer_rules(
          Tesla.Env.client(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.EnvelopeTransferRuleInformation.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def envelope_transfer_rules_get_envelope_transfer_rules(connection, account_id, opts \\ []) do
    optional_params = %{
      :count => :query,
      :start_position => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/envelopes/transfer_rules")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.EnvelopeTransferRuleInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Creates an envelope transfer rule.
  This method creates an envelope transfer rule.  When you create an envelope transfer rule, you specify the following properties:   - `eventType` - `fromGroups` - `toUser` - `toFolder` - `carbonCopyOriginalOwner` - `enabled`  **Note:** Only Administrators can create envelope transfer rules. In addition, to use envelope transfer rules, the **Transfer Custody** feature must be enabled for your account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (EnvelopeTransferRuleRequest):

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeTransferRuleInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec envelope_transfer_rules_post_envelope_transfer_rules(
          Tesla.Env.client(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.EnvelopeTransferRuleInformation.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def envelope_transfer_rules_post_envelope_transfer_rules(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/envelopes/transfer_rules")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, %DocuSign.Model.EnvelopeTransferRuleInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Changes the status of an envelope transfer rule.
  This method changes the status of an envelope transfer rule. You use this method to change whether or not the rule is enabled.  You must include the `envelopeTransferRuleId` both as a query parameter, and in the request body.  **Note:** You cannot change any other information about the envelope transfer rule. Only Administrators can update an envelope transfer rule. In addition, to use envelope transfer rules, the **Transfer Custody** feature must be enabled for your account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `envelope_transfer_rule_id` (String.t): The ID of the envelope transfer rule. The system generates this ID when the rule is first created.
  - `opts` (keyword): Optional parameters
    - `:body` (EnvelopeTransferRule):

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeTransferRule.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec envelope_transfer_rules_put_envelope_transfer_rule(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.EnvelopeTransferRule.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def envelope_transfer_rules_put_envelope_transfer_rule(
        connection,
        account_id,
        envelope_transfer_rule_id,
        opts \\ []
      ) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/envelopes/transfer_rules/#{envelope_transfer_rule_id}")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.EnvelopeTransferRule{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Changes the status of multiple envelope transfer rules.
  This method changes the status for one or more envelope transfer rules based on the `envelopeTransferRuleId`s in the request body. You use this method to change whether or not the rules are enabled.  **Note:** You cannot change any other information about the envelope transfer rule. Only Administrators can update envelope transfer rules. In addition, to use envelope transfer rules, the **Transfer Custody** feature must be enabled for your account.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (EnvelopeTransferRuleInformation):

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeTransferRuleInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec envelope_transfer_rules_put_envelope_transfer_rules(
          Tesla.Env.client(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.EnvelopeTransferRuleInformation.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def envelope_transfer_rules_put_envelope_transfer_rules(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/envelopes/transfer_rules")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.EnvelopeTransferRuleInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end