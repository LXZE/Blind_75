defmodule Helper do
  def list_sort(list_str) do
    Enum.sort(list_str, fn a, b ->
      length(a) < length(b)
    end)
    |> Enum.map(&Enum.sort/1)
  end
end

defmodule Solution do
  defp create_counter(str) do
    String.codepoints(str) |> Enum.frequencies
  end

  @spec group_anagrams(strs :: [String.t]) :: [[String.t]]
  def group_anagrams(strs) do
    Enum.map(strs, fn str ->
      {create_counter(str), str}
    end)
    |> Enum.reduce(%{}, fn {key, str}, acc ->
      Map.update(acc, key, [str], &[str | &1])
    end)
    |> Map.values
  end
end

tests = [
  %{input: ["eat","tea","tan","ate","nat","bat"], expect: [["bat"],["nat","tan"],["ate","eat","tea"]]},
  %{input: [""], expect: [[""]]},
  %{input: ["a"], expect: [["a"]]},
]

for %{input: strs, expect: unsorted_expect} <- tests do
  expect = Helper.list_sort(unsorted_expect)
  Solution.group_anagrams(strs) |> Helper.list_sort
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
