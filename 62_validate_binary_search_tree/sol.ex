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
  @min_finite (-2147483648 - 1)
  @max_finite (2147483647 + 1)

  def valid?(_, left_val \\ @min_finite, right_val \\ @max_finite)
  def valid?(nil, _, _), do: true
  def valid?(%TreeNode{val: node_val}, left_val, right_val)
    when not (left_val < node_val and node_val < right_val), do: false
  def valid?(node, left_val, right_val) do
    Enum.all?([
      valid?(node.left, left_val, node.val),
      valid?(node.right, node.val, right_val)
    ])
  end

  @spec is_valid_bst(root :: TreeNode.t | nil) :: boolean
  def is_valid_bst(root) do
    valid?(root)
  end
end

null = nil
tests = [
  %{input: [2,1,3], expect: true},
  %{input: [5,1,4,null,null,3,6], expect: false},
  %{input: [1,null,1], expect: false},
  %{input: [0,-1], expect: true},
  %{input: [5,4,6,null,null,3,7], expect: false},
  %{input: [2147483647], expect: true},
]

for %{input: input, expect: expect} <- tests do
  Solution.is_valid_bst(Helper.gentree(input))
  # |> Helper.detree
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
