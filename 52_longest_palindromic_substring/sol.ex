defmodule Solution do
  def search_odd(c, p, {_, max}) when c-p < 0 or c+p > max, do: (c-(p-1))..(c+p-1)
  def search_odd(c, p, {str, _} = const) do # center, padding
    if elem(str, c - p) == elem(str, c + p), do: search_odd(c, p+1, const),
    else: (c-(p-1))..(c+(p-1))
  end

  def search_even(l, r, {_, max}) when l < 0 or r > max, do: (l+1)..(r-1)
  def search_even(l, r, {str, _} = const) do
    if elem(str, l) == elem(str, r), do: search_even(l-1, r+1, const),
    else: (l+1)..(r-1)
  end

  def longest_range(ranges) do
    Enum.max_by(ranges, &Range.size/1)
  end

  @spec longest_palindrome(s :: String.t) :: String.t
  def longest_palindrome(s) do
    if String.length(s) == 1 do s
    else
      {str, str_len} = String.codepoints(s)
      |> then(fn ls ->
        {List.to_tuple(ls), length(ls)-1}
      end)

      for i <- 1..str_len, reduce: 0..0 do
        acc ->
          res = if elem(str, i-1) == elem(str, i) do
            res_even = search_even(i-1, i, {str, str_len})
            res_odd = search_odd(i, 0, {str, str_len})
            [res_even, res_odd]
          else
            [search_odd(i, 0, {str, str_len})]
          end
          longest_range([acc | res])
      end
      |> (&String.slice(s, &1)).()
    end
  end
end

tests = [
  %{input: "babad", expect: "bab"},
  %{input: "cbbd", expect: "bb"},
  %{input: "a", expect: "a"},
]

for %{input: strs, expect: expect} <- tests do
  Solution.longest_palindrome(strs)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
