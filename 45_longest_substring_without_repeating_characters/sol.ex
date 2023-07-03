defmodule Solution do
  defp substrlen(_, [], _, _, res), do: res
  defp substrlen(left, [next | tail] = right, idx_l, idx_r, res) do
    {new_l, new_r, new_idx_l, new_idx_r, new_res} = case Enum.member?(left, next) do
      true -> {tl(left), right, idx_l + 1, idx_r, res} # shift left
      false -> {left ++ [next], tail, idx_l, idx_r + 1, max(res, idx_r - idx_l + 1)} # shift right
    end
    substrlen(new_l, new_r, new_idx_l, new_idx_r, new_res)
  end

  @spec length_of_longest_substring(s :: String.t) :: integer
  def length_of_longest_substring(s) do
    substrlen([], String.codepoints(s), 0, 0, 0)
  end
end


big_case = File.read!("big.txt") |> Code.eval_string |> elem(0)

tests = [
  %{input: "abcabcbb", expect: 3},
  %{input: "bbbbb", expect: 1},
  %{input: "pwwkew", expect: 3},
  %{input: big_case, expect: 95},
]

for %{input: input, expect: expect} <- tests do
  Solution.length_of_longest_substring(input)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
