defmodule DocuSign.Util do
  @moduledoc false

  @doc """
  Performs a root-level conversion of map keys from strings to atoms.

  This function performs the transformation safely using `String.to_existing_atom/1`, but this has a possibility to raise if
  there is not a corresponding atom.

  It is recommended that you pre-filter maps for known values before
  calling this function.

  ## Examples

  iex> map = %{
  ...>   "a"=> %{
  ...>     "b" => %{
  ...>       "c" => 1
  ...>     }
  ...>   }
  ...> }
  iex> DocuSign.Util.map_keys_to_atoms(map)
  %{
  a: %{
  "b" => %{
  "c" => 1
  }
  }
  }
  """
  def map_keys_to_atoms(m) do
    Enum.into(m, %{}, fn
      {k, v} when is_binary(k) ->
        a = String.to_existing_atom(k)
        {a, v}

      entry ->
        entry
    end)
  end
end
