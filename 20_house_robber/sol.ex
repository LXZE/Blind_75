defmodule Solution do
  @spec rob(nums :: [integer]) :: integer
  def rob(nums) do
    for n <- nums, reduce: {0, 0} do {r1, r2} -> {r2, max(n+r1, r2)} end
    |> elem(1)
  end
end

tests = [
  %{input: [1,2,3,1], expect: 4},
  %{input: [2,7,9,3,1], expect: 12},
]

for %{input: n, expect: expect} <- tests do
  Solution.rob(n) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
