defmodule DocuSign do
  alias DocuSign.APIClient

  @moduledoc """
  Documentation for DocuSign.
  """

  @doc """
  Retrieves information for the current DocuSign user.

  ## Examples

      iex> DocuSign.user_info()
      {}

  """
  def user_info do
    APIClient.user_info()
  end
end
