defmodule Solution do
  def shift_l(l, r, counter, {k, chars} = const) do
    longest_substr = Map.values(counter) |> Enum.max
    # if current window len - longest substr > replaceable count = need shift left
    # ex baabb, k = 1 then shift left until ok
    case ((r - l + 1) - longest_substr) > k do
      true -> shift_l(l+1, r, Map.update!(counter, Enum.at(chars, l), & &1-1), const)
      false -> {l, counter}
    end
  end

  @spec character_replacement(s :: String.t, k :: integer) :: integer
  def character_replacement(s, k) do
    char_list = String.to_charlist(s)
    char_list
    |> Enum.with_index
    |> Enum.reduce({0, 0, Map.new()}, fn {char, r}, {l, res, counter} ->
      {new_l, new_counter} = Map.update(counter, char, 1, & &1+1)
      |> then(&shift_l(l, r, &1, {k, char_list}))
      {new_l, max(res, r - new_l + 1), new_counter}
    end)
    |> elem(1)
  end
end


tests = [
  %{input: %{s: "ABAB", k: 2}, expect: 4},
  %{input: %{s: "AABABBA", k: 1}, expect: 4},
]

for %{input: %{s: s, k: k}, expect: expect} <- tests do
  Solution.character_replacement(s, k)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
