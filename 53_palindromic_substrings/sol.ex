defmodule Solution do
  def search_odd(c, p, const, acc \\ 1)
  def search_odd(c, p, {_, max}, acc) when c-p < 0 or c+p > max, do: acc - 1
  def search_odd(c, p, {str, _} = const, acc) do # center, padding
    if elem(str, c - p) == elem(str, c + p), do: search_odd(c, p+1, const, acc + 1),
    else: acc - 1
  end

  def search_even(l, r, const, acc \\ 1)
  def search_even(l, r, {_, max}, acc) when l < 0 or r > max, do: acc - 1
  def search_even(l, r, {str, _} = const, acc) do
    if elem(str, l) == elem(str, r), do: search_even(l-1, r+1, const, acc + 1),
    else: acc - 1
  end

  @spec count_substrings(s :: String.t) :: integer
  def count_substrings(s) do
    {str, str_len} = String.codepoints(s)
    |> then(fn ls ->
      {List.to_tuple(ls), length(ls)-1}
    end)

    for i <- 0..str_len, reduce: 0 do
      acc ->
        count = if tuple_size(str) > 1 and i > 0 and elem(str, i-1) == elem(str, i) do
          search_even(i-1, i, {str, str_len}) + search_odd(i, 0, {str, str_len})
        else
          search_odd(i, 0, {str, str_len})
        end
        acc + count
    end
  end
end

tests = [
  %{input: "abc", expect: 3},
  %{input: "aaa", expect: 6},
  %{input: "a", expect: 1},
]

for %{input: s, expect: expect} <- tests do
  Solution.count_substrings(s)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
