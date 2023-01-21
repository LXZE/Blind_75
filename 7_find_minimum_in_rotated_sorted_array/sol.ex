defmodule Solution do
  # if search pointer collide = return min
  def search(_, {min, l_idx, r_idx}) when l_idx > r_idx, do: min
  def search(nums, {min, l_idx, r_idx}) do
    {l, r} = {Enum.at(nums, l_idx), Enum.at(nums, r_idx)}
    if l < r do # l < r = sorted correctly, return either minimum or left value
      min(min, l)
    else
      pivot_idx = div(l_idx + r_idx, 2)
      pivot = Enum.at(nums, pivot_idx)
      new_state = {min(min, pivot), l_idx, r_idx}
      |> (&
        # if left val < pivot == left side sorted, then search right side
        if l<=pivot, do: put_elem(&1, 1, pivot_idx+1),
        # else, search left side
        else: put_elem(&1, 2, pivot_idx-1)
      ).()
      search(nums, new_state)
    end
  end
  @spec find_min(nums :: [integer]) :: integer
  def find_min(nums) do
    # bin search -> O(log n)
    search(nums, {hd(nums), 0, length(nums) - 1})
  end
end

tests = [
  %{input: [3,4,5,1,2], expect: 1},
  %{input: [4,5,6,7,0,1,2], expect: 0},
  %{input: [11,13,15,17], expect: 11},
  %{input: [1], expect: 1},
  %{input: [2,1], expect: 1},
]

for %{input: input, expect: expect} <- tests do
  Solution.find_min(input) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
