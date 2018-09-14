defmodule DocusignTest do
  use ExUnit.Case
  doctest Docusign

  test "greets the world" do
    assert Docusign.hello() == :world
  end
end
