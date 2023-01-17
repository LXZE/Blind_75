defmodule Solution do
  @spec max_product(nums :: [integer]) :: integer
  def max_product([hd | []]), do: hd
  def max_product([hd | tl]) do
    # {min, max, result}
    Enum.reduce(tl, {hd, hd, hd}, fn num, {min, max, res} ->
      [new_min, _, new_max] = Enum.sort([num, num*min, num*max])
      {new_min, new_max, max(res, new_max)}
    end) |> elem(2)
  end
end

tests = [
  %{input: [2,3,-2,4], expect: 6},
  %{input: [-2,0,-1], expect: 0},
]

for %{input: input, expect: expect} <- tests do
  Solution.max_product(input) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
