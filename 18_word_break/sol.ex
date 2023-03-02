defmodule Solution do
  def search(pointer, {str, word_dict}, dp) do
    Enum.reduce_while(0..pointer-1, dp, fn idx, acc ->
      if elem(dp, idx) and String.slice(str, idx..pointer-1) in word_dict, do:
        {:halt, Tuple.append(acc, true)},
      else:
        {:cont, acc}
    end)
    |> (& if tuple_size(&1) == pointer+1, do: &1, else: Tuple.append(&1, false)).()
  end

  @spec word_break(s :: String.t, word_dict :: [String.t]) :: boolean
  def word_break(s, word_dict) do
    for pointer <- 1..String.length(s), reduce: {true} do
      dp -> search(pointer, {s, word_dict}, dp)
    end
    |> Tuple.to_list |> List.last
  end
end

tests = [
  %{input: %{s: "leetcode", wordDict: ["leet","code"]}, expect: true},
  %{input: %{s: "applepenapple", wordDict: ["apple","pen"]}, expect: true},
  %{input: %{s: "catsandog", wordDict: ["cats","dog","sand","and","cat"]}, expect: false},
]

for %{input: %{s: t1, wordDict: t2}, expect: expect} <- tests do
  Solution.word_break(t1, t2) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
