defmodule Solution do
  def grid_to_map(grid) do
    Enum.with_index(grid) |> Enum.reduce(%{}, fn {row, row_idx}, base ->
      Enum.with_index(row) |> Enum.reduce(base, fn {elem, col_idx}, acc ->
        Map.put(acc, {row_idx, col_idx}, elem)
      end)
    end)
  end

  def expand_land({row, col}, visited, lands) do
    expanded = [{row, col+1}, {row, col-1}, {row+1, col}, {row-1, col}]
      |> Enum.filter(fn cell ->
        not MapSet.member?(visited, cell) and MapSet.member?(lands, cell)
      end)
    case length(expanded) > 0 do
      true -> for cell <- expanded, reduce: visited do acc ->
        expand_land(cell, MapSet.union(acc, MapSet.new([cell])), lands)
      end
      false -> visited
    end
  end

  def count_island(lands, count \\ 0) do
    case MapSet.size(lands) == 0 do
      true -> count
      false -> cell = MapSet.to_list(lands) |> hd
        island = expand_land(cell, MapSet.new([cell]), lands)
        count_island(MapSet.difference(lands, island), count + 1)
    end
  end

  @spec num_islands(grid :: [[char]]) :: integer
  def num_islands(grid) do
    map = grid_to_map(grid)
    Map.to_list(map)
      |> Enum.filter(fn {_, val} -> val == ?1 end)
      |> Enum.map(&elem(&1, 0)) |> MapSet.new
      |> count_island
  end
end

tests = [
  %{input: ['11110', '11010', '11000', '00000'], expect: 1},
  %{input: ['11000', '11000', '00100', '00011'], expect: 3},
]

for %{input: grid, expect: expect} <- tests do
  Solution.num_islands(grid) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
