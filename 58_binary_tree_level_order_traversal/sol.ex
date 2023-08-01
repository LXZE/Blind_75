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
  def traverse(_, level \\ 0)
  def traverse(nil, _), do: nil
  def traverse(%TreeNode{val: v, left: l, right: r}, level) do
    [{v, level}, traverse(l, level+1), traverse(r, level+1)]
    |> Enum.reject(& &1 == nil)
    |> List.flatten
  end

  @spec level_order(root :: TreeNode.t | nil) :: [[integer]]
  def level_order(root) do
    traverse(root) |> List.wrap
    |> Enum.reject(&is_tuple(&1) && elem(&1, 0) == nil)
    |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
    |> Map.to_list
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
  end
end

null = nil
tests = [
  %{input: [3,9,20,null,null,15,7], expect: [[3],[9,20],[15,7]]},
  %{input: [1], expect: [[1]]},
  %{input: [], expect: []},
]

for %{input: root, expect: expect} <- tests do
  Solution.level_order(Helper.gentree(root))
  # |> Helper.detree
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
