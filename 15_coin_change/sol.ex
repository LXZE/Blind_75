defmodule Solution do
  def dp(current, _, amount, acc) when current > amount, do: elem(acc, amount)
    |> (&if(&1 == (amount + 1), do: -1, else: &1)).()
  def dp(current, coins, amount, acc) do
    min_dp = Enum.filter(coins, fn coin -> current - coin >= 0 end)
    |> Enum.map(fn coin -> 1 + elem(acc, current - coin) end)
    |> Enum.concat([amount + 1])
    |> Enum.min
    dp(current + 1, coins, amount, Tuple.append(acc, min_dp))
  end

  @spec coin_change(coins :: [integer], amount :: integer) :: integer
  def coin_change(_, 0), do: 0
  def coin_change(coins, amount) do
    dp(1, coins, amount, {0})
  end
end

tests = [
  %{input: %{coins: [1,2,5], amount: 11}, expect: 3},
  %{input: %{coins: [2], amount: 3}, expect: -1},
  %{input: %{coins: [1], amount: 0}, expect: 0},
  %{input: %{coins: [1,3,4,5], amount: 7}, expect: 2},
  %{input: %{coins: [484,395,346,103,329], amount: 4259}, expect: 11},
  %{input: %{coins: [470,35,120,81,121], amount: 9825}, expect: 30},
]

for %{input: %{coins: c, amount: a}, expect: expect} <- tests do
  Solution.coin_change(c, a) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
