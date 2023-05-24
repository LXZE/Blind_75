defmodule Solution do
  def loop(ranges, new_range) do
    { disjointed, overlapped } = Enum.split_with(ranges, &Range.disjoint?(&1, new_range))
    case length(overlapped) == 0 do
      true -> [new_range | disjointed]
      false ->
        merged_range = Enum.reduce(overlapped, new_range, fn range_a..range_b, acc_a..acc_b ->
          min(range_a, acc_a)..max(range_b, acc_b)
        end)
        loop(disjointed, merged_range)
    end
  end

  @spec insert(intervals :: [[integer]], new_interval :: [integer]) :: [[integer]]
  def insert(intervals, [new_a, new_b]) do
    Enum.map(intervals, fn [a, b] -> a..b end)
    |> loop(Range.new(new_a, new_b))
    |> Stream.map(fn a..b -> [a, b] end)
    |> Enum.sort(fn [a, _], [b, _] -> a < b end)
  end
end

tests = [
  %{input: %{intervals: [[1,3],[6,9]], newInterval: [2,5]}, expect: [[1,5],[6,9]]},
  %{input: %{intervals: [[1,2],[3,5],[6,7],[8,10],[12,16]], newInterval: [4,8]}, expect: [[1,2],[3,10],[12,16]]},
]

for %{input: %{intervals: arr, newInterval: new}, expect: expect} <- tests do
  Solution.insert(arr, new) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
