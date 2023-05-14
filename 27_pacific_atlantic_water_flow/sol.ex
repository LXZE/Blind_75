defmodule Solution do
  def list_to_map(lst) do
    Enum.with_index(lst) |> Enum.reduce(%{}, fn {row, row_idx}, res ->
      Enum.with_index(row) |> Enum.reduce(res, fn {elem, col_idx}, acc ->
        Map.put(acc, {row_idx, col_idx}, elem)
      end)
    end)
  end

  # find the higher from the lower point
  def reachable(to_visit, visited, {cells, max_row, max_col}) do
    case MapSet.size(to_visit) do
      0 -> visited
      _ -> [{row, col} | tl] = MapSet.to_list(to_visit)
      next_cells = [{row, col+1}, {row, col-1}, {row+1, col}, {row-1, col}]
      |> Enum.filter(fn {next_row, next_col} ->
        next_row in 0..max_row and next_col in 0..max_col and # in range
        not MapSet.member?(visited, {next_row, next_col}) and # not visited
        cells[{row, col}] <= cells[{next_row, next_col}] # candidate is higher
      end) |> MapSet.new
      next_to_visit = MapSet.new(tl) |> MapSet.union(next_cells)
      reachable(next_to_visit, MapSet.union(visited, next_cells), {cells, max_row, max_col})
    end
  end

  @spec pacific_atlantic(heights :: [[integer]]) :: [[integer]]
  def pacific_atlantic(heights) do
    max_row = length(heights) - 1
    max_col = length(hd(heights)) - 1
    top_seed = Enum.concat(
      Enum.map(0..max_row, fn row -> {row, 0} end), #{row, col}
      Enum.map(0..max_col, fn col -> {0, col} end)
    ) |> MapSet.new()
    bot_seed = Enum.concat(
      Enum.map(0..max_row, fn row -> {row, max_col} end),
      Enum.map(0..max_col, fn col -> {max_row, col} end)
    ) |> MapSet.new()
    matrix = list_to_map(heights)

    top_reachable = reachable(top_seed, top_seed, {matrix, max_row, max_col})
    bot_reachable = reachable(bot_seed, bot_seed, {matrix, max_row, max_col})
    MapSet.intersection(top_reachable, bot_reachable)
    |> Enum.to_list |> Enum.map(fn {x, y} -> [x, y] end)
  end
end

tests = [
  %{input: [[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]], expect: [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]},
  %{input: [[1]], expect: [[0,0]]},
]

for %{input: input, expect: expect} <- tests do
  Solution.pacific_atlantic(input) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
