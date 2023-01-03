defmodule Solution do
  def two_sum([{num, idx} | tl], target, mem) do
    if Map.has_key?(mem, num), do: [mem[num], idx],
    else: two_sum(tl, target, Map.put(mem, target-num, idx))
  end
  @spec two_sum(nums :: [integer], target :: integer) :: [integer]
  def two_sum(nums, target) do
    two_sum(Enum.with_index(nums), target, %{})
  end
end

tests = [
  %{input: [[2,7,11,15], 9], result: [0,1]},
  %{input: [[3,2,4], 6], result: [1,2]},
  %{input: [[3,3], 6], result: [0,1]},
  %{input: [1..10000, 19999], result: [9998,9999]}
]

for %{input: [nums, target], result: result} <- tests do
  dbg(Solution.two_sum(nums, target) == result)
end
