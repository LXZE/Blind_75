# Definition for a binary tree node.
defmodule TreeNode do
  @type t :: %__MODULE__{
          val: integer,
          left: TreeNode.t() | nil,
          right: TreeNode.t() | nil
        }
  defstruct val: 0, left: nil, right: nil
end

defmodule Helper do
  def gentree(lst), do: do_gentree({List.to_tuple(lst), length(lst)})
  defp do_gentree(const, index \\ 0)
  defp do_gentree({_, size}, index) when index >= size, do: nil
  defp do_gentree({lst, _} = const, index) do
    if elem(lst, index) == nil, do: nil,
    else: %TreeNode{
        val: elem(lst, index),
        left: do_gentree(const, 2*index+1), right: do_gentree(const, 2*index+2)
      }
  end

  def detree(tree), do: do_detree(tree) |> List.wrap |> List.flatten
    |> Enum.sort_by(& elem(&1, 1), :desc)
    |> Stream.drop_while(& elem(&1, 0) == nil)
    |> Stream.map(& elem(&1, 0))
    |> Enum.reverse
  defp do_detree(tree, offset \\ 0)
  defp do_detree(nil, offset), do: {nil, offset}
  defp do_detree(%TreeNode{val: v, left: l, right: r}, offset) do
    [{v, offset}, do_detree(l, 2*offset+1), do_detree(r, 2*offset+2)]
  end
end

defmodule Solution do
  @spec max_path_sum(root :: TreeNode.t | nil) :: integer
  def max_path_sum(root), do: traverse(root) |> elem(0)

  def traverse(nil), do: {Float.min_finite, Float.min_finite}
  def traverse(%TreeNode{val: v, left: l, right: r}) do
    {sum_l, path_l} = traverse(l)
    {sum_r, path_r} = traverse(r)
    [path_l, path_r] = [path_l, path_r] |> Enum.map(&max(&1, 0))
    {
      # sum = max of left or right or current + all branches
      Enum.max([sum_l, sum_r, v+path_l+path_r]),
      # sum of root and maximum branch
      v + max(max(path_l, path_r), 0)
    }
  end
end

null = nil
tests = [
  %{input: [1,2,3], expect: 6},
  %{input: [-10,9,20,null,null,15,7], expect: 42},
  %{input: [1,-2,-3,1,3,-2,null,-1], expect: 3},
  %{input: [1,-2,3], expect: 4},
  %{input: [-3], expect: -3},
]

for %{input: root, expect: expect} <- tests do
  Solution.max_path_sum(Helper.gentree(root))
  # |> Helper.detree
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
