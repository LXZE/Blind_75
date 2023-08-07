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
  @spec build_tree(preorder :: [integer], inorder :: [integer]) :: TreeNode.t | nil
  def build_tree(_, []), do: nil
  def build_tree([], _), do: nil
  def build_tree([hd_pre | _] = preorder, inorder) do
    mid = Enum.find_index(inorder, & &1 == hd_pre)
    %TreeNode{
      val: hd_pre,
      left: build_tree(
        Enum.slice(preorder, 1..mid),
        Enum.slice(inorder, 0..(mid-1))
      ),
      right: build_tree(
        Enum.slice(preorder, (mid+1)..-1),
        Enum.slice(inorder, (mid+1)..-1)
      ),
    }
  end
end

big_case = File.read!("big.txt") |> Code.eval_string |> elem(0)
big_case_ans = File.read!("big_ans.txt") |> Code.eval_string |> elem(0)

null = nil
tests = [
  %{input: %{preorder: [3,9,20,15,7], inorder: [9,3,15,20,7]}, expect: [3,9,20,null,null,15,7]},
  %{input: %{preorder: [-1], inorder: [-1]}, expect: [-1]},
  %{input: big_case, expect: big_case_ans},
]

for %{input: %{preorder: preorder, inorder: inorder}, expect: expect} <- tests do
  Solution.build_tree(preorder, inorder)
  |> Helper.detree
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
