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
  def traverse(nil), do: nil
  def traverse(%TreeNode{val: v, left: l, right: r}) do
    [traverse(l), v, traverse(r)] # BST = sorted
  end

  @spec kth_smallest(root :: TreeNode.t | nil, k :: integer) :: integer
  def kth_smallest(root, k) do
    traverse(root) |> List.flatten |> Stream.reject(&is_nil/1) |> Enum.at(k-1)
  end
end

null = nil
tests = [
  %{input: %{root: [3,1,4,null,2], k: 1}, expect: 1},
  %{input: %{root: [5,3,6,2,4,null,null,1], k: 3}, expect: 3},
]

for %{input: %{root: root, k: k}, expect: expect} <- tests do
  Solution.kth_smallest(Helper.gentree(root), k)
  # |> Helper.detree
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
