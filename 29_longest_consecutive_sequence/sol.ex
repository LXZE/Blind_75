defmodule Solution do
  # end case
  def count([_ | []], seq), do: seq
  def count([h1, h2 | tl], [last | prev_seqs]) do
    new_seq = case h2 - h1 do
      1 -> last + 1
      _ -> 1
    end
    count([h2 | tl], [new_seq, last | prev_seqs])
  end

  @spec longest_consecutive(nums :: [integer]) :: integer
  def longest_consecutive([]), do: 0
  def longest_consecutive(nums) do
    Stream.uniq(nums) |> Enum.sort
    |> count([1]) |> Enum.max
  end
end

big_case = File.read!("big.txt") |> Code.eval_string |> elem(0)

tests = [
  %{input: [100,4,200,1,3,2], expect: 4},
  %{input: [0,3,7,2,5,8,4,6,0,1], expect: 9},
  %{input: [], expect: 0},
  %{input: big_case, expect: 100000},
]

for %{input: arr, expect: expect} <- tests do
  Solution.longest_consecutive(arr) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
