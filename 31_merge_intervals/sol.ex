defmodule Solution do
  def insert(ranges, new_range) do
    { disjointed, overlapped } = Enum.split_with(ranges, &Range.disjoint?(&1, new_range))
    if length(overlapped) == 0 do [new_range | disjointed] else
        merged_range = Enum.reduce(overlapped, new_range, fn range_a..range_b, acc_a..acc_b ->
          min(range_a, acc_a)..max(range_b, acc_b)
        end)
        insert(disjointed, merged_range)
    end
  end

  @spec merge(intervals :: [[integer]]) :: [[integer]]
  def merge(intervals) do
    Enum.sort(intervals, fn [a, _], [b, _] -> a < b end)
    |> Enum.map(fn [a, b] -> a..b end)
    |> Enum.reduce([], &insert(&2, &1))
    |> Enum.map(fn a..b -> [a,b] end)
    |> Enum.sort(fn [a, _], [b, _] -> a < b end)
  end
end

tests = [
  %{input: [[1,3],[2,6],[8,10],[15,18]], expect: [[1,6],[8,10],[15,18]]},
  %{input: [[1,4],[4,5]], expect: [[1,5]]},
  %{input: [], expect: []},
]

for %{input: nums, expect: expect} <- tests do
  Solution.merge(nums) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
