defmodule DocuSign.Request do
  @hostname Application.get_env(:docusign, :hostname)

  def post_form(path, form_data, auth_token) do
    HTTPoison.post(
      url(path),
      {:form, form_data},
      with_auth_header(auth_token, [{"Content-Type", "application/x-www-form-urlencoded"}])
    )
  end

  def get(path, params, auth_token) do
    HTTPoison.get(url(path, params), with_auth_header(auth_token, []))
  end

  ###
  # Private functions
  ##

  defp url(path, params \\ []) do
    "https://#{@hostname}/#{path}"
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  def with_auth_header(nil, headers), do: headers

  def with_auth_header(auth_token, headers) do
    [{"Authorization", auth_token.token} | headers]
  end
end
