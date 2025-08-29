defmodule DocuSign.AtomizeTest do
  use ExUnit.Case, async: true

  alias DocuSign.Model.EnvelopeSummary

  test "atomize_keys works with EnvelopeSummary atoms" do
    # First, ensure the module is loaded so atoms exist
    _ = %EnvelopeSummary{}

    # This is what Req returns - string keys
    response_body = %{
      "envelopeId" => "b24e6c1c-4269-4098-a84d-06d4c072a915",
      "status" => "sent",
      "statusDateTime" => "2025-08-31T22:01:23.9770000Z",
      "uri" => "/envelopes/b24e6c1c-4269-4098-a84d-06d4c072a915"
    }

    # Try to atomize the keys
    atomized = atomize_keys(response_body)

    assert atomized[:envelopeId] == "b24e6c1c-4269-4098-a84d-06d4c072a915"
    assert atomized[:status] == "sent"

    # Now decode it
    decoded = EnvelopeSummary.decode(atomized)
    assert %EnvelopeSummary{} = decoded
    assert decoded.envelopeId == "b24e6c1c-4269-4098-a84d-06d4c072a915"
  end

  # Copy the function from RequestBuilder to test it
  defp atomize_keys(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      {String.to_existing_atom(k), atomize_keys(v)}
    end)
  rescue
    ArgumentError ->
      # If atom doesn't exist, fall back to creating it (careful with memory)
      Map.new(map, fn {k, v} ->
        {String.to_atom(k), atomize_keys(v)}
      end)
  end

  defp atomize_keys(list) when is_list(list) do
    Enum.map(list, &atomize_keys/1)
  end

  defp atomize_keys(value), do: value
end
