defmodule Solution do
  def search(_, _, nil, _, acc), do: acc
  def search(_, _, l, r, acc) when l >= r, do: acc
  def search(nums, val_1, l, r, acc) do
    [val_2, val_3] = [l, r] |> Enum.map(&elem(nums, &1))
    sum = val_1+val_2+val_3
    {new_l, new_r, new_acc} = cond do
      sum > 0 -> {l, r-1, acc}
      sum < 0 -> {l+1, r, acc}
      true -> {
        Enum.find(l+1..r, &(elem(nums, &1) > val_2)),
        r,
        acc ++ [[val_1,val_2,val_3]]
      }
    end
    search(nums, val_1, new_l, new_r, new_acc)
  end

  @spec three_sum(nums :: [integer]) :: [[integer]]
  def three_sum(nums) do
    last_idx = length(nums) - 1
    sorted_nums = Enum.sort(nums)
    Enum.with_index(sorted_nums)
    |> Enum.reduce({hd(sorted_nums), []}, fn {val_1, idx_1}, {prev_val, ans} ->
      if idx_1 > 0 && val_1 == prev_val, do: {prev_val, ans},
      else: {val_1, ans ++ search(List.to_tuple(sorted_nums), val_1, idx_1+1, last_idx, [])}
    end) |> elem(1)
  end
end

big_case = File.read!("big.txt") |> Code.eval_string |> elem(0)
big_case_result = File.read!("res.txt") |> Code.eval_string |> elem(0)

tests = [
  %{input: [-1,0,1,2,-1,-4], expect: [[-1,-1,2],[-1,0,1]]},
  %{input: [0,1,1], expect: []},
  %{input: [0,0,0], expect: [[0,0,0]]},
  %{input: big_case, expect: big_case_result},
]

for %{input: nums, expect: expect} <- tests do
  Solution.three_sum(nums) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
