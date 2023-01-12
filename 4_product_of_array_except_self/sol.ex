defmodule Solution do
  def create_product(nums) do
    Enum.map_reduce(nums, 1, fn item, acc ->
      item*acc |> (&{&1, &1}).()
    end) |> elem(0)
  end
  @spec product_except_self(nums :: [integer]) :: [integer]
  def product_except_self(nums) do
    [1 | nums] |> List.delete_at(-1)
    |> create_product |> Stream.zip(nums) |> Enum.reverse
    |> Enum.map_reduce(1, fn {pre, new}, acc ->
      {pre*acc, acc*new}
    end)
    |> elem(0) |> Enum.reverse
  end
end

tests = [
  %{input: [1,2,3,4], expect: [24,12,8,6]},
  %{input: [-1,1,0,-3,3], expect: [0,0,9,0,0]},
]

for %{input: input, expect: expect} <- tests do
  Solution.product_except_self(input) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
