defmodule Solution do
  def dp([], _, dp), do: Tuple.to_list(dp) |> Enum.max()
  def dp([hd | tl], prev, dp) do
    new_dp = Tuple.to_list(prev)
    |> Enum.with_index
    |> Enum.filter(fn {elem, _} -> elem > hd end) # find which previous val is greater
    |> Enum.map(&elem(dp, elem(&1, 1))+1) # result in 1 + that position
    |> (&Enum.max([1 | &1])).() # dp = max(1 | previous + 1)
    dp(tl, Tuple.append(prev, hd), Tuple.append(dp, new_dp))
  end

  @spec length_of_lis(nums :: [integer]) :: integer
  def length_of_lis(nums) do
    [hd | tl] = Enum.reverse(nums)
    dp(tl, {hd}, {1})
  end
end

tests = [
  %{input: [10,9,2,5,3,7,101,18], expect: 4},
  %{input: [0,1,0,3,2,3], expect: 4},
  %{input: [7,7,7,7,7,7,7], expect: 1},
  %{input: [1,2,4,3], expect: 3},
  %{input: [1,2,3,4], expect: 4},
]

for %{input: n, expect: expect} <- tests do
  Solution.length_of_lis(n) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
