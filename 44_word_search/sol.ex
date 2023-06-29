defmodule Solution do
  def convert_board(board) do
    for {row, row_idx} <- Enum.with_index(board),
      {elem, col_idx} <- Enum.with_index(row), reduce: %{} do
      acc -> put_in(acc, [{row_idx, col_idx}], elem)
    end
  end

  def search_candidate(board, target) do
    Enum.filter(board, fn {_, elem} -> elem == target end)
    |> Enum.map(& elem(&1, 0))
  end

  def exist?({_, target, _, _}, _, _) when target == "", do: true
  def exist?({board, target, rows, cols}, {current_row, current_col}, prev_state) do
    candidates = [{-1, 0}, {1, 0}, {0, 1}, {0, -1}]
    |> Enum.map(fn {dr, dc} -> {current_row+dr, current_col+dc} end)
    |> Enum.filter(fn {row, col} ->
      row in 0..rows and col in 0..cols
      and not MapSet.member?(prev_state, {row, col})
    end)
    |> Enum.map(&{&1, get_in(board, [&1])})
    |> Enum.filter(fn {_, c} -> String.at(target, 0) == c end)
    # |> dbg

    # dbg({current_row, current_col})
    # dbg(candidates)
    # dbg({target, String.at(target, 0)})
    case length(candidates) do
      0 -> false
      _ -> Stream.map(candidates, fn {pos, _} ->
          exist?(
            {board, String.slice(target, 1..-1), rows, cols},
            pos,
            MapSet.put(prev_state, pos)
          )
        end)
        |> Enum.any?
    end
  end

  def is_feasible?(board, target) do
    Enum.any?(board, fn {_, c} -> c == target end)
  end

  @spec exist(board :: [[char]], word :: String.t) :: boolean
  def exist(board, word) do
    map_board = convert_board(board)
    if is_feasible?(map_board, String.at(word, -1)) do
      [candidate_l, candidate_r] = [0, -1]
      |> Enum.map(&search_candidate(map_board, String.at(word, &1)))
      if length(candidate_l) <= length(candidate_r) do
        Stream.map(candidate_l, &exist?(
            {map_board, String.slice(word, 1..-1), length(board)-1, length(hd(board))-1},
            &1,
            MapSet.new([&1])
          ))
        |> Enum.any?
      else
        Stream.map(candidate_r, &exist?(
            {map_board, String.slice(word, 0..-2) |> String.reverse, length(board)-1, length(hd(board))-1},
            &1,
            MapSet.new([&1])
          ))
        |> Enum.any?
      end
    else
      false
    end
  end
end

tests = [
  %{input: %{board: [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word: "ABCCED"}, expect: true},
  %{input: %{board: [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word: "SEE"}, expect: true},
  %{input: %{board: [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word: "ABCB"}, expect: false},
  %{input: %{board: [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word: "ABCCED"}, expect: true},
  %{input: %{board: [["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"]], word: "AAAAAAAAAAAAAAB"}, expect: false},
  %{input: %{board: [["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"]], word: "BAAAAAAAAAAAAAA"}, expect: false},
  %{input: %{board: [["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","A"],["A","A","A","A","A","B"],["A","A","A","A","B","A"]], word: "AAAAAAAAAAAAABB"}, expect: false},
  %{input: %{board: [["a","b","c"],["a","e","d"],["a","f","g"]], word: "abcdefg"}, expect: true},
]

for %{input: %{board: board, word: word}, expect: expect} <- tests do
  Solution.exist(board, word)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
