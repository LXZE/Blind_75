defmodule Solution do
  @spec climb_stairs(n :: integer) :: integer
  def climb_stairs(1), do: 1
  def climb_stairs(n) do
    Enum.reduce(2..n, {1, 1}, fn _, {a, b} ->
      {b, a+b}
    end) |> elem(1)
  end
end

tests = [
  %{input: 1, expect: 1},
  %{input: 2, expect: 2},
  %{input: 3, expect: 3},
  %{input: 44, expect: 1134903170},
]

for %{input: n, expect: expect} <- tests do
  Solution.climb_stairs(n) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
