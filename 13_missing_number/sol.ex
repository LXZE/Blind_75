defmodule Solution do
  @spec missing_number(nums :: [integer]) :: integer
  def missing_number(nums) do
    Enum.with_index(nums)
    |> Enum.reduce(length(nums), fn {e, i}, acc ->
      acc + (i - e)
    end)
  end
end

tests = [
  %{input: [3,0,1], expect: 2},
  %{input: [0,1], expect: 2},
  %{input: [9,6,4,2,3,5,7,0,1], expect: 8},
]

for %{input: n, expect: expect} <- tests do
  Solution.missing_number(n) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
