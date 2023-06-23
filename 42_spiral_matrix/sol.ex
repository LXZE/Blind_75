defmodule Solution do
  def rotate_matrix(matrix) do
    Enum.zip_with(matrix, & &1) |> Enum.reverse
  end

  def loop(_, acc \\ [])
  def loop([], acc), do: acc
  def loop([hd | tl], acc), do: loop(rotate_matrix(tl), acc++hd)

  @spec spiral_order(matrix :: [[integer]]) :: [integer]
  def spiral_order(matrix) do
    loop(matrix)
  end
end

tests = [
  %{input: [[1,2,3],[4,5,6],[7,8,9]], expect: [1,2,3,6,9,8,7,4,5]},
  %{input: [[1,2,3,4],[5,6,7,8],[9,10,11,12]], expect: [1,2,3,4,8,12,11,10,9,5,6,7]},
]

for %{input: input, expect: expect} <- tests do
  Solution.spiral_order(input)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
