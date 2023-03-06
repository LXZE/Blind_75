defmodule Solution do
  def search(_, current, total, {_, target}, res) when total == target, do: [current | res]
  def search(idx, current, total, {candidates, target}, res) do
    cond do
      idx >= tuple_size(candidates) or total > target -> res
      true ->
        candidate = elem(candidates, idx)
        new_current = current ++ [candidate]
        # search if current pointer duplicated
        res_l = search(idx, new_current, total + candidate, {candidates, target}, res)
        # search if no current pointer in result
        res_r = search(idx + 1, current, total, {candidates, target}, res)
        Enum.concat(res_l, res_r)
    end
  end

  @spec combination_sum(candidates :: [integer], target :: integer) :: [[integer]]
  def combination_sum(candidates, target) do
    search(0, [], 0, {List.to_tuple(candidates), target}, [])
  end
end

tests = [
  %{input: %{candidates: [2,3,6,7], target: 7}, expect: [[2,2,3],[7]]},
  %{input: %{candidates: [2,3,5], target: 8}, expect: [[2,2,2,2],[2,3,3],[3,5]]},
  %{input: %{candidates: [2], target: 1}, expect: []},
]

for %{input: %{candidates: c, target: t}, expect: expect} <- tests do
  Solution.combination_sum(c, t) |> (&[result: &1, expect: expect, correct?: Enum.sort(&1)==Enum.sort(expect)]).()
end
|> dbg
# |> dbg(limit: :infinity)
