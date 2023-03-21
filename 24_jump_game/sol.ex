defmodule Solution do
  def df(_, -1, res), do: res == 0
  def df(nums, idx, res) do
    new_res = if idx + elem(nums, idx) >= res, do: idx, else: res
    df(nums, idx-1, new_res)
  end

  @spec can_jump(nums :: [integer]) :: boolean
  def can_jump(nums) do
    last = length(nums) - 1
    df(List.to_tuple(nums), last, last)
  end
end

tests = [
  %{input: [2,3,1,1,4], expect: true},
  %{input: [3,2,1,0,4], expect: false},
]

for %{input: nums, expect: expect} <- tests do
  Solution.can_jump(nums) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
