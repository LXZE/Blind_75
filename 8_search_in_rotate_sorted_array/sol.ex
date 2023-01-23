defmodule Solution do
  def find_idx(_, _, {l_idx, r_idx}) when l_idx > r_idx, do: -1
  def find_idx(nums, target, {l_idx, r_idx}) do
    {l, r} = {Enum.at(nums, l_idx), Enum.at(nums, r_idx)}
    pivot_idx = div(l_idx+r_idx, 2)
    pivot = Enum.at(nums, pivot_idx)
    cond do
      pivot == target -> pivot_idx
      l <= pivot -> # left side sorted
        if target in l..pivot, do: find_idx(nums, target, {l_idx, pivot_idx-1}),
        else: find_idx(nums, target, {pivot_idx+1, r_idx})
      pivot <= r -> # right side sorted
        if target in pivot..r, do: find_idx(nums, target, {pivot_idx+1, r_idx}),
        else: find_idx(nums, target, {l_idx, pivot_idx-1})
    end
  end
  @spec search(nums :: [integer], target :: integer) :: integer
  def search(nums, target) do
    find_idx(nums, target, {0, length(nums)-1})
  end
end

tests = [
  %{input: {[4,5,6,7,0,1,2], 0}, expect: 4},
  %{input: {[4,5,6,7,0,1,2], 3}, expect: -1},
  %{input: {[1], 0}, expect: -1},
]

for %{input: {nums, target}, expect: expect} <- tests do
  Solution.search(nums, target) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
