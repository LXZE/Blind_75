defmodule Solution do
  def rm_last(nums), do: nums |> Enum.reverse |> tl |> Enum.reverse
  def dp(nums) do
    for n <- nums, reduce: {0, 0} do {r1, r2} -> {r2, max(n+r1, r2)} end
    |> elem(1)
  end

  @spec rob(nums :: [integer]) :: integer
  def rob([hd | []]), do: hd
  def rob([hd | tl]) do
    max(dp(tl), dp(rm_last([hd | tl])))
  end
end

tests = [
  %{input: [2,3,2], expect: 3},
  %{input: [1,2,3,1], expect: 4},
  %{input: [1,2,3], expect: 3},
  %{input: [1], expect: 1},
]

for %{input: n, expect: expect} <- tests do
  Solution.rob(n) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
