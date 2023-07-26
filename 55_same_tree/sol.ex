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

  def detree(tree), do: do_detree(tree) |> List.flatten
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
  @spec is_same_tree(p :: TreeNode.t | nil, q :: TreeNode.t | nil) :: boolean
  def is_same_tree(p, q) do
    # p == q
    equal(p, q)
  end

  def equal(nil, nil), do: true
  def equal(p, q) when p == nil or q == nil, do: false
  def equal(p, q) do
    if p.val == q.val, do: Enum.all?([equal(p.left, q.left), equal(p.right, q.right)]),
    else: false
  end
end

tests = [
  %{input: %{p: [1,2,3], q: [1,2,3]}, expect: true},
  %{input: %{p: [1,2], q: [1,nil,2]}, expect: false},
  %{input: %{p: [1,2,1], q: [1,1,2]}, expect: false},
  %{input: %{p: [10,5,15], q: [10,5,nil,nil,15]}, expect: false},
]

for %{input: %{p: p, q: q}, expect: expect} <- tests do
  Solution.is_same_tree(Helper.gentree(p), Helper.gentree(q))
  # |> Helper.detree
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
