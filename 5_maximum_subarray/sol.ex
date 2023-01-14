defmodule Solution do
  @spec max_sub_array(nums :: [integer]) :: integer
  def max_sub_array([hd | tl]) do
    # acc = {current, max}
    Enum.reduce(tl, {hd, hd}, fn num, {current, max} ->
      current = max(0, current) + num # if current <= 0, disregard
      {current, max(max, current)} # keep current sum and max result
    end)
    |> elem(1)
  end
end

tests = [
  %{input: [-2,1,-3,4,-1,2,1,-5,4], expect: 6},
  %{input: [1], expect: 1},
  %{input: [5,4,-1,7,8], expect: 23},
  %{input: [-1], expect: -1},
  %{input: [-1,-1], expect: -1},
]

for %{input: input, expect: expect} <- tests do
  Solution.max_sub_array(input) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
