defmodule DocuSignTest do
  use ExUnit.Case
  doctest DocuSign

  test "greets the world" do
    assert DocuSign.hello() == :world
  end
end
