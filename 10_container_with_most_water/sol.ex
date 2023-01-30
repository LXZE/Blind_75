defmodule Solution do
  def calc(_, l, r, res) when l >= r, do: res
  def calc(height, l, r, res) when l < r do
    [val_l, val_r] = [l, r] |> Enum.map(&elem(height, &1))
    area = min(val_l, val_r) * (r-l)
    new_res = max(res, area)
    {new_l, new_r} = cond do
      val_l < val_r -> {l+1, r}
      true -> {l, r-1}
    end
    calc(height, new_l, new_r, new_res)
  end

  @spec max_area(height :: [integer]) :: integer
  def max_area(height) do
    calc(List.to_tuple(height), 0, length(height) - 1, 0)
  end
end

big_case = File.read!("big.txt") |> Code.eval_string |> elem(0)

tests = [
  %{input: [1,8,6,2,5,4,8,3,7], expect: 49},
  %{input: [1,1], expect: 1},
  %{input: [2,3,4,5,18,17,6], expect: 17},
  %{input: big_case, expect: 705634720},
]

for %{input: nums, expect: expect} <- tests do
  Solution.max_area(nums) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
