defmodule Solution do
  @mask 65535
  @spec get_sum(a :: integer, b :: integer) :: integer
  def get_sum(a, b) do
    res = Stream.repeatedly(fn -> nil end) |> Enum.reduce_while({a, b}, fn _, {pa, pb} ->
      case pb do
        0 -> {:halt, pa}
        _ -> tmp = Bitwise.&&&(pa, pb) |> Bitwise.<<<(1)
          new_a = Bitwise.^^^(pa, pb) |> Bitwise.&&&(@mask)
          new_b = Bitwise.&&&(tmp, @mask)
          {:cont, {new_a, new_b}}
      end
    end)
    if res > 32767, do: Bitwise.^^^(res, @mask) |> Bitwise.bnot, else: res
  end
end


tests = [
  %{input: %{a: 1, b: 2}, expect: 3},
  %{input: %{a: 2, b: 3}, expect: 5},
]

for %{input: %{a: a, b: b}, expect: expect} <- tests do
  Solution.get_sum(a, b) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
