defmodule Solution do
  def take_last(tup), do: Tuple.to_list(tup) |> List.last
  def loop(current, limit, data) when current == limit, do: data
  def loop(current, limit, data) do
    new_data = Stream.iterate({0, 0}, fn {idx, val} -> {idx+1, elem(data, idx) + val} end)
    |> Stream.take(tuple_size(data)+1) # include stream init element {0, 0}
    |> Enum.map(fn {_, val} -> val end) |> tl |> List.to_tuple
    loop(current+1, limit, new_data)
  end

  @spec unique_paths(m :: integer, n :: integer) :: integer
  def unique_paths(1, _), do: 1
  def unique_paths(_, 1), do: 1
  def unique_paths(m, n) do
    [low, hi] = Enum.sort([m, n])
    loop(2, low, Enum.to_list(1..hi) |> List.to_tuple) |> take_last
  end
end

tests = [
  %{input: %{m: 3, n: 7}, expect: 28},
  %{input: %{m: 2, n: 7}, expect: 7},
  %{input: %{m: 4, n: 7}, expect: 84},
  %{input: %{m: 5, n: 7}, expect: 210},
  %{input: %{m: 6, n: 7}, expect: 462},
  %{input: %{m: 7, n: 7}, expect: 924},
  %{input: %{m: 100, n: 100}, expect: 22750883079422934966181954039568885395604168260154104734000},
  %{input: %{m: 3, n: 2}, expect: 3},
]

for %{input: %{m: m, n: n}, expect: expect} <- tests do
  Solution.unique_paths(m, n) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
