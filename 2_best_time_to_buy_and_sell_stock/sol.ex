defmodule Solution do
  @spec max_profit(prices :: [integer]) :: integer
  def max_profit(prices) do
    [hd | tl] = prices
    Enum.reduce(tl, {hd, 0}, fn cur_price, {prev_min, profit} ->
      new_min = min(prev_min, cur_price)
      {new_min, max(profit, cur_price - new_min)}
    end) |> elem(1)
  end
end

big_case = File.read!("big.txt") |> Code.eval_string |> elem(0)

tests = [
  %{input: [7,1,5,3,6,4], result: 5},
  %{input: [7,6,4,3,1], result: 0},
  %{input: [2,4,1], result: 2},
  %{input: [1,2,4,2,5,7,2,4,9,0,9], result: 9},
  %{input: big_case, result: 999}
]

for %{input: input, result: result} <- tests do
  dbg(Solution.max_profit(input) == result)
end
