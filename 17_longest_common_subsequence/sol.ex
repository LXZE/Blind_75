defmodule Solution do
  def get(table, key), do: :ets.lookup(table, key) |> hd |> elem(1)

  @spec longest_common_subsequence(text1 :: String.t, text2 :: String.t) :: integer
  def longest_common_subsequence(text1, text2) do
    table = :ets.new(:dp, [])
    [l1, l2] = [String.length(text1), String.length(text2)]
    for i <- 0..(l1+1), j <- 0..(l2+1), do: :ets.insert(table, {{i, j}, 0})
    [t1, t2] = [&String.graphemes/1, &List.to_tuple/1]
    |> Enum.reduce([text1, text2], fn fun, acc -> Enum.map(acc, fun) end)

    for i <- 1..l1, j <- 1..l2 do
      update_val= if elem(t1, i-1) == elem(t2, j-1),
        do: get(table, {i-1, j-1}) + 1,
        else: max(get(table, {i-1, j}), get(table, {i, j-1}))
      :ets.insert(table, {{i, j}, update_val})
    end
    get(table, {l1, l2})
  end
end

long_str = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
large_input1 = %{text1: long_str, text2: long_str}

tests = [
  %{input: %{text1: "abcde", text2: "ace" }, expect: 3},
  %{input: %{text1: "abc", text2: "abc"}, expect: 3},
  %{input: %{text1: "abc", text2: "def"}, expect: 0},
  %{input: %{text1: "pmjghexybyrgzczy", text2: "hafcdqbgncrcbihkd"}, expect: 4},
  %{input: large_input1, expect: 1000},
]

for %{input: %{text1: t1, text2: t2}, expect: expect} <- tests do
  Solution.longest_common_subsequence(t1, t2) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
