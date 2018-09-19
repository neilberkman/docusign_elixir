defmodule DocuSign.UtilTest do
  use ExUnit.Case
  import DocuSign.Util

  test 'map_keys_to_atoms' do
    assert map_keys_to_atoms(%{"test" => 1}) == %{test: 1}
  end
end
