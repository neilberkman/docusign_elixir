# NOTE: This file is auto generated by OpenAPI Generator 6.4.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule DocuSign.Api.Templates do
  @moduledoc """
  API calls for all endpoints tagged `Templates`.
  """

  alias DocuSign.Connection
  import DocuSign.RequestBuilder

  @doc """
  Gets template notification information.
  Retrieves the envelope notification, reminders and expirations, information for an existing template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters

  ### Returns

  - `{:ok, DocuSign.Model.Notification.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec notification_get_templates_template_id_notification(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.Notification.t()}
          | {:error, Tesla.Env.t()}
  def notification_get_templates_template_id_notification(
        connection,
        account_id,
        template_id,
        _opts \\ []
      ) do
    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/notification")
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.Notification{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates the notification  structure for an existing template.
  Updates the notification structure for an existing template. Use this endpoint to set reminder and expiration notifications.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (TemplateNotificationRequest):

  ### Returns

  - `{:ok, DocuSign.Model.Notification.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec notification_put_templates_template_id_notification(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.Notification.t()}
          | {:error, Tesla.Env.t()}
  def notification_put_templates_template_id_notification(
        connection,
        account_id,
        template_id,
        opts \\ []
      ) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/notification")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.Notification{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Deletes a page from a document in an template.
  Deletes a page from a document in a template based on the page number.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `document_id` (String.t): The unique ID of the document within the envelope.  Unlike other IDs in the eSignature API, you specify the `documentId` yourself. Typically the first document has the ID `1`, the second document `2`, and so on, but you can use any numbering scheme that fits within a 32-bit signed integer (1 through 2147483647).   Tab objects have a `documentId` property that specifies the document on which to place the tab.
  - `page_number` (String.t): The page number being accessed.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (PageRequest):

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec pages_delete_template_page(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def pages_delete_template_page(
        connection,
        account_id,
        document_id,
        page_number,
        template_id,
        opts \\ []
      ) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url(
        "/v2.1/accounts/#{account_id}/templates/#{template_id}/documents/#{document_id}/pages/#{page_number}"
      )
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets a page image from a template for display.
  Retrieves a page image for display from the specified template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `document_id` (String.t): The unique ID of the document within the envelope.  Unlike other IDs in the eSignature API, you specify the `documentId` yourself. Typically the first document has the ID `1`, the second document `2`, and so on, but you can use any numbering scheme that fits within a 32-bit signed integer (1 through 2147483647).   Tab objects have a `documentId` property that specifies the document on which to place the tab.
  - `page_number` (String.t): The page number being accessed.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:dpi` (String.t): The number of dots per inch (DPI) for the resulting images. Valid values are 1-310 DPI. The default value is 94.
    - `:max_height` (String.t): Sets the maximum height of the returned images in pixels.
    - `:max_width` (String.t): Sets the maximum width of the returned images in pixels.
    - `:show_changes` (String.t):

  ### Returns

  - `{:ok, String.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec pages_get_template_page_image(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, DocuSign.Model.ErrorDetails.t()} | {:ok, String.t()} | {:error, Tesla.Env.t()}
  def pages_get_template_page_image(
        connection,
        account_id,
        document_id,
        page_number,
        template_id,
        opts \\ []
      ) do
    optional_params = %{
      :dpi => :query,
      :max_height => :query,
      :max_width => :query,
      :show_changes => :query
    }

    request =
      %{}
      |> method(:get)
      |> url(
        "/v2.1/accounts/#{account_id}/templates/#{template_id}/documents/#{document_id}/pages/#{page_number}/page_image"
      )
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, false},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Returns document page images based on input.
  Returns images of the pages in a template document for display based on the parameters that you specify.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): (Required) The external account number (int) or account ID GUID.
  - `document_id` (String.t): (Required) The ID of the document.
  - `template_id` (String.t): (Required) The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:count` (String.t): The maximum number of results to return.
    - `:dpi` (String.t): The number of dots per inch (DPI) for the resulting images. Valid values are 1-310 DPI. The default value is 94.
    - `:max_height` (String.t): Sets the maximum height of the returned images in pixels.
    - `:max_width` (String.t): Sets the maximum width of the returned images in pixels.
    - `:nocache` (String.t): When **true,** using cache is disabled and image information is retrieved from a database. **True** is the default value.
    - `:show_changes` (String.t): When **true,** changes display in the user interface.
    - `:start_position` (String.t): The position within the total result set from which to start returning values. The value **thumbnail** may be used to return the page image.

  ### Returns

  - `{:ok, DocuSign.Model.PageImages.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec pages_get_template_page_images(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.PageImages.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def pages_get_template_page_images(connection, account_id, document_id, template_id, opts \\ []) do
    optional_params = %{
      :count => :query,
      :dpi => :query,
      :max_height => :query,
      :max_width => :query,
      :nocache => :query,
      :show_changes => :query,
      :start_position => :query
    }

    request =
      %{}
      |> method(:get)
      |> url(
        "/v2.1/accounts/#{account_id}/templates/#{template_id}/documents/#{document_id}/pages"
      )
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.PageImages{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Rotates page image from a template for display.
  Rotates page image from a template for display. The page image can be rotated to the left or right.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `document_id` (String.t): The unique ID of the document within the envelope.  Unlike other IDs in the eSignature API, you specify the `documentId` yourself. Typically the first document has the ID `1`, the second document `2`, and so on, but you can use any numbering scheme that fits within a 32-bit signed integer (1 through 2147483647).   Tab objects have a `documentId` property that specifies the document on which to place the tab.
  - `page_number` (String.t): The page number being accessed.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (PageRequest):

  ### Returns

  - `{:ok, nil}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec pages_put_template_page_image(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) :: {:ok, nil} | {:ok, DocuSign.Model.ErrorDetails.t()} | {:error, Tesla.Env.t()}
  def pages_put_template_page_image(
        connection,
        account_id,
        document_id,
        page_number,
        template_id,
        opts \\ []
      ) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url(
        "/v2.1/accounts/#{account_id}/templates/#{template_id}/documents/#{document_id}/pages/#{page_number}/page_image"
      )
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

  @doc """
  Removes a member group's sharing permissions for a template.
  Removes a member group's sharing permissions for a specified template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `template_part` (String.t): Currently, the only defined part is **groups.**
  - `opts` (keyword): Optional parameters
    - `:body` (GroupInformation):

  ### Returns

  - `{:ok, DocuSign.Model.GroupInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec templates_delete_template_part(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.GroupInformation.t()}
          | {:error, Tesla.Env.t()}
  def templates_delete_template_part(
        connection,
        account_id,
        template_id,
        template_part,
        opts \\ []
      ) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:delete)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/#{template_part}")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.GroupInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets a specific template associated with a specified account.
  Retrieves the definition of the specified template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:include` (String.t): A comma-separated list of additional template attributes to include in the response. Valid values are:  - `powerforms`: Includes information about PowerForms. - `tabs`: Includes information about tabs. - `documents`: Includes information about documents. - `favorite_template_status`: : Includes the template `favoritedByMe` property in the response. **Note:** You can mark a template as a favorite only in eSignature v2.1.

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeTemplate.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec templates_get_template(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.EnvelopeTemplate.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def templates_get_template(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :include => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.EnvelopeTemplate{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Gets the list of templates.
  Retrieves the list of templates for the specified account. The request can be limited to a specific folder.  ### Related topics  - [How to create a template](/docs/esign-rest-api/how-to/create-template/)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:count` (String.t): The maximum number of results to return.  Use `start_position` to specify the number of results to skip.
    - `:created_from_date` (String.t): Lists templates created on or after this date.
    - `:created_to_date` (String.t): Lists templates modified before this date.
    - `:folder_ids` (String.t): A comma-separated list of folder ID GUIDs.
    - `:folder_types` (String.t): The type of folder to return templates for. Possible values are:  - `templates`: Templates in the **My Templates** folder.   Templates in the **Shared Templates**  and **All Template** folders (if the request ID from and Admin) are excluded. - `templates_root`: Templates in the root level of the **My Templates** folder, but not in an actual folder. Note that the **My Templates** folder is not a real folder. - `recylebin`: Templates that have been deleted.
    - `:from_date` (String.t): Start of the search date range. Only returns templates created on or after this date/time. If no value is specified, there is no limit on the earliest date created.
    - `:include` (String.t): A comma-separated list of additional template attributes to include in the response. Valid values are:  - `powerforms`: Includes details about the PowerForms associated with the templates. - `documents`: Includes information about template documents. - `folders`: Includes information about the folder that holds the template. - `favorite_template_status`: Includes the template `favoritedByMe` property. **Note:** You can mark a template as a favorite only in eSignature v2.1. - `advanced_templates`: Includes information about advanced templates. - `recipients`: Includes information about template recipients. - `custom_fields`: Includes information about template custom fields. - `notifications`: Includes information about the notification settings for templates.
    - `:is_deleted_template_only` (String.t): When **true,** retrieves templates that have been permanently deleted. The default is **false.**  **Note:** After you delete a template, you can see it in the `Deleted` bin in the UI for 24 hours. After 24 hours, the template is permanently deleted.
    - `:is_download` (String.t): When **true,** downloads the templates listed in `template_ids` as a collection of JSON definitions in a single zip file.  The `Content-Disposition` header is set in the response. The value of the header provides the filename of the file.  The default is **false.**  **Note:** This parameter only works when you specify a list of templates in the `template_ids` parameter.
    - `:modified_from_date` (String.t): Lists templates modified on or after this date.
    - `:modified_to_date` (String.t): Lists templates modified before this date.
    - `:order` (String.t): Specifies the sort order of the search results. Valid values are:  - `asc`: Ascending (A to Z) - `desc`: Descending (Z to A)
    - `:order_by` (String.t): Specifies how the search results are listed. Valid values are:  - `name`: template name - `modified`: date/time template was last modified - `used`: date/time the template was last used.
    - `:search_fields` (String.t): A comma-separated list of additional template properties to search.   - `sender`: Include sender name and email in the search. - `recipients`: Include recipient names and emails in the search. - `envelope`: Not used in template searches.
    - `:search_text` (String.t): The text to use to search the names of templates.  Limit: 48 characters.
    - `:shared_by_me` (String.t): When **true,** the response only includes templates shared by the user. If false, the response only returns template not shared by the user. If not specified, the response is not affected.
    - `:start_position` (String.t): The zero-based index of the result from which to start returning results.  Use with `count` to limit the number of results.  The default value is `0`.
    - `:template_ids` (String.t): A comma-separated list of template IDs to download. This value is valid only when `is_download` is **true.**
    - `:to_date` (String.t): The end of a search date range in UTC DateTime format. When you use this parameter, only templates created up to this date and time are returned.  **Note:** If this property is null, the value defaults to the current date.
    - `:used_from_date` (String.t): Start of the search date range. Only returns templates used or edited on or after this date/time. If no value is specified, there is no limit on the earliest date used.
    - `:used_to_date` (String.t): End of the search date range. Only returns templates used or edited up to this date/time. If no value is provided, this defaults to the current date.
    - `:user_filter` (String.t): Filters the templates in the response. Valid values are:   - `owned_by_me`: Results include only templates owned by the user. - `shared_with_me`: Results include only templates owned by the user.   - `all`:  Results include all templates owned or shared with the user.
    - `:user_id` (String.t): The ID of the user.

  ### Returns

  - `{:ok, DocuSign.Model.EnvelopeTemplateResults.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec templates_get_templates(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.EnvelopeTemplateResults.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def templates_get_templates(connection, account_id, opts \\ []) do
    optional_params = %{
      :count => :query,
      :created_from_date => :query,
      :created_to_date => :query,
      :folder_ids => :query,
      :folder_types => :query,
      :from_date => :query,
      :include => :query,
      :is_deleted_template_only => :query,
      :is_download => :query,
      :modified_from_date => :query,
      :modified_to_date => :query,
      :order => :query,
      :order_by => :query,
      :search_fields => :query,
      :search_text => :query,
      :shared_by_me => :query,
      :start_position => :query,
      :template_ids => :query,
      :to_date => :query,
      :used_from_date => :query,
      :used_to_date => :query,
      :user_filter => :query,
      :user_id => :query
    }

    request =
      %{}
      |> method(:get)
      |> url("/v2.1/accounts/#{account_id}/templates")
      |> add_optional_params(optional_params, opts)
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.EnvelopeTemplateResults{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Creates one or more templates.
  Creates one or more template definitions, using a multipart request for each template.  [Templates](/docs/esign-rest-api/esign101/concepts/templates/) help streamline the sending process when you frequently send the same or similar documents, or send different documents to the same group of people.  When you create a template, you define placeholder roles. Rather than specifying a person, you specify a role that regularly participates in a transaction that uses the template. Then, when you create or send an envelope based on the template, you assign actual recipients to the template roles. The recipients automatically inherit all of the workflow that is defined for that role in the template, such as the tabs and routing information.  ## Template Email Subject Merge Fields  Placeholder roles have associated merge fields that personalize the email notification that DocuSign sends. For example, the template automatically personalizes the email message by adding placeholders for the recipient's name and email address within the email subject line, based on the recipient's role. When the sender adds the name and email information for the recipient and sends the envelope, the recipient information is automatically merged into the appropriate fields in the email subject line.  Both the sender and the recipients will see the information in the email subject line for any emails associated with the template. This provides an easy way for senders to organize their envelope emails without having to open an envelope to find out who the recipient is.    Use the following placeholders to insert a recipient's name or email address in the subject line  To insert a recipient's name into the subject line, use the `[[<roleName>_UserName]]` placholder in the  `emailSubject` property when you create the template:  To include a recipient's name or email address in the subject line, use the following placeholders in the `emailSubject` property:  - `[[<roleName>_UserName]]` - `[[<roleName>_Email]]`   For example, if the role name is `Signer 1`, you might set `emailSubject` to one of these strings:  - `\"[[Signer 1_UserName]], Please sign this NDA\"` - `\"[[Signer 1_Email]], Please sign this NDA\"`   **Note:** The maximum length of the subject line is 100 characters, including any merged text.   ## Creating multiple templates  To create multiple templates, you provide a zip file of JSON files. You can also use the Templates::ListTemplates method with the `is_download` query parameter to download a zip file containing your existing templates and use that as a guide. The API supports both .zip and .gzip file formats as input.  You also need to set the `Content-Length`, `Content-Type`, and `Content-Disposition` headers:   ``` Content-Length: 71068 Content-Type: application/zip Content-Disposition: file; filename=\"DocuSignTemplates_Nov_25_2019_20_40_21.zip\"; fileExtension=.zip ```  ### Related topics  - [How to create a template](/docs/esign-rest-api/how-to/create-template/)

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): (Required) The external account number (int) or account ID GUID.
  - `opts` (keyword): Optional parameters
    - `:body` (EnvelopeTemplate):

  ### Returns

  - `{:ok, DocuSign.Model.TemplateSummary.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec templates_post_templates(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.TemplateSummary.t()}
          | {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:error, Tesla.Env.t()}
  def templates_post_templates(connection, account_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:post)
      |> url("/v2.1/accounts/#{account_id}/templates")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {201, %DocuSign.Model.TemplateSummary{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Updates an existing template.
  Updates an existing template.

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `opts` (keyword): Optional parameters
    - `:body` (EnvelopeTemplate):

  ### Returns

  - `{:ok, DocuSign.Model.TemplateUpdateSummary.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec templates_put_template(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.TemplateUpdateSummary.t()}
          | {:error, Tesla.Env.t()}
  def templates_put_template(connection, account_id, template_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.TemplateUpdateSummary{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end

  @doc """
  Shares a template with a group.
  Shares a template with the specified members group.  **Note:** For a newer version of this functionality, see [Accounts: Update Shared Access](/docs/esign-rest-api/reference/accounts/accounts/updatesharedaccess/).

  ### Parameters

  - `connection` (DocuSign.Connection): Connection to server
  - `account_id` (String.t): The external account number (int) or account ID GUID.
  - `template_id` (String.t): The ID of the template.
  - `template_part` (String.t): Currently, the only defined part is **groups.**
  - `opts` (keyword): Optional parameters
    - `:body` (GroupInformation):

  ### Returns

  - `{:ok, DocuSign.Model.GroupInformation.t}` on success
  - `{:error, Tesla.Env.t}` on failure
  """
  @spec templates_put_template_part(
          Tesla.Env.client(),
          String.t(),
          String.t(),
          String.t(),
          keyword()
        ) ::
          {:ok, DocuSign.Model.ErrorDetails.t()}
          | {:ok, DocuSign.Model.GroupInformation.t()}
          | {:error, Tesla.Env.t()}
  def templates_put_template_part(connection, account_id, template_id, template_part, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    request =
      %{}
      |> method(:put)
      |> url("/v2.1/accounts/#{account_id}/templates/#{template_id}/#{template_part}")
      |> add_optional_params(optional_params, opts)
      |> ensure_body()
      |> Enum.into([])

    connection
    |> Connection.request(request)
    |> evaluate_response([
      {200, %DocuSign.Model.GroupInformation{}},
      {400, %DocuSign.Model.ErrorDetails{}}
    ])
  end
end
