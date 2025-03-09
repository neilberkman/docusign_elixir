defmodule DocuSign.ModelCleaner do
  @moduledoc """
  Provides functions to clean DocuSign models before sending to the API.

  This module helps remove nil values from model structs to improve API compatibility.
  """
  require Logger

  @doc """
  Clean a DocuSign API request body to remove nil values from structs.
  This function gets applied by the RequestBuilder automatically.

  The function handles the following cases:
  - Structs are converted to maps and nil values are removed
  - Maps have their nil values removed
  - Lists are processed recursively
  - Other values are passed through unchanged
  """
  def clean(nil), do: nil

  def clean(%{__struct__: _} = struct) do
    struct
    |> Map.from_struct()
    |> clean()
  end

  def clean(%{} = map) do
    map
    |> Enum.reject(fn {_k, v} -> is_nil(v) end)
    |> Enum.map(fn {k, v} -> {k, clean(v)} end)
    |> Enum.into(%{})
  end

  def clean(list) when is_list(list) do
    Enum.map(list, &clean/1)
  end

  def clean(other), do: other
end
