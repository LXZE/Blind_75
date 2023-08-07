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
  def compare(nil, _), do: false
  def compare(tree1, tree2) when tree1 == tree2, do: true
  def compare(%TreeNode{left: left, right: right}, tree2) do
    Enum.any?([compare(left, tree2), compare(right, tree2)])
  end

  @spec is_subtree(root :: TreeNode.t | nil, sub_root :: TreeNode.t | nil) :: boolean
  def is_subtree(root, sub_root) do
    compare(root, sub_root)
  end
end

null = nil
tests = [
  %{input: %{root: [3,4,5,1,2], subRoot: [4,1,2]}, expect: true},
  %{input: %{root: [3,4,5,1,2,null,null,null,null,0], subRoot: [4,1,2]}, expect: false},
]

for %{input: %{root: root, subRoot: sub}, expect: expect} <- tests do
  Solution.is_subtree(Helper.gentree(root), Helper.gentree(sub))
  # |> Helper.detree
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
