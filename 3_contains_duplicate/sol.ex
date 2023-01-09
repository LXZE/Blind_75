defmodule Solution do
  @spec contains_duplicate(nums :: [integer]) :: boolean
  def contains_duplicate(nums), do: check(nums, %{})
  defp check([], _), do: false
  defp check([hd | tl], mem) do
    case mem[hd] do
      nil -> check(tl, Map.put(mem, hd, 0))
      _ -> true
    end
  end
end

tests = [
  %{input: [1,2,3,1], expect: true},
  %{input: [1,2,3,4], expect: false},
  %{input: [1,1,1,3,3,4,3,2,4,2], expect: true},
]

for %{input: input, expect: expect} <- tests do
  Solution.contains_duplicate(input) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
