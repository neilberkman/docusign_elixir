defmodule DocuSign.ModelCleanerTest do
  use ExUnit.Case, async: true

  alias DocuSign.ModelCleaner

  # Define the test struct at module level, not inside a test
  defmodule TestStruct do
    defstruct a: nil, b: 2, c: nil
  end

  describe "clean/1" do
    test "returns nil when given nil" do
      assert ModelCleaner.clean(nil) == nil
    end

    test "passes through primitive values unchanged" do
      assert ModelCleaner.clean("string") == "string"
      assert ModelCleaner.clean(123) == 123
      assert ModelCleaner.clean(true) == true
      assert ModelCleaner.clean(false) == false
      assert ModelCleaner.clean(:atom) == :atom
    end

    test "removes nil values from maps" do
      map = %{a: 1, b: nil, c: 3}
      expected = %{a: 1, c: 3}
      assert ModelCleaner.clean(map) == expected
    end

    test "recursively cleans nested maps" do
      map = %{
        a: 1,
        b: nil,
        c: %{
          d: 4,
          e: nil,
          f: %{g: 7, h: nil}
        }
      }

      expected = %{
        a: 1,
        c: %{
          d: 4,
          f: %{g: 7}
        }
      }

      assert ModelCleaner.clean(map) == expected
    end

    test "recursively cleans lists of maps" do
      list = [
        %{a: 1, b: nil},
        %{c: 3, d: %{e: 5, f: nil}}
      ]

      expected = [
        %{a: 1},
        %{c: 3, d: %{e: 5}}
      ]

      assert ModelCleaner.clean(list) == expected
    end

    test "handles structs" do
      struct = %TestStruct{a: nil, b: 2, c: nil}
      expected = %{b: 2}

      assert ModelCleaner.clean(struct) == expected
    end
  end
end
