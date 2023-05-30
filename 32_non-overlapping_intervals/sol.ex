defmodule Solution do
  @spec erase_overlap_intervals(intervals :: [[integer]]) :: integer
  def erase_overlap_intervals(intervals) do # count overlap instead, cuz overlapped range = amount need remove
    [[_, prev_r] | tl] = Enum.sort(intervals)
    for [l, r] <- tl, reduce: {0, prev_r} do
      {acc, prev_r} -> if l >= prev_r, do: {acc, r}, else: {acc+1, min(r, prev_r)}
    end |> elem(0)
  end
end


tests = [
  %{input: [[1,2],[2,3],[3,4],[1,3]], expect: 1},
  %{input: [[1,2],[1,2],[1,2]], expect: 2},
  %{input: [[1,2],[2,3]], expect: 0},
]

for %{input: nums, expect: expect} <- tests do
  Solution.erase_overlap_intervals(nums) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
