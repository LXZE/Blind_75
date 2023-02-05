defmodule Solution do
  @spec count_bits(n :: integer) :: [integer]
  def count_bits(0), do: [0]
  def count_bits(n) do
    for i <- 1..n, reduce: {1, {0}} do
      {offset, acc} ->
        new_offset = if(offset * 2 == i, do: i, else: offset)
        { new_offset, Tuple.append(acc, 1 + elem(acc, i - new_offset)) }
    end
    |> elem(1) |> Tuple.to_list
  end
end

tests = [
  %{input: 2, expect: [0,1,1]},
  %{input: 5, expect: [0,1,1,2,1,2]},
  %{input: 0, expect: [0]},
]

for %{input: n, expect: expect} <- tests do
  Solution.count_bits(n) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
