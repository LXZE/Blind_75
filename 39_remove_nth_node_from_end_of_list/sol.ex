# Definition for singly-linked list.
defmodule ListNode do
  @type t :: %__MODULE__{
          val: integer,
          next: ListNode.t() | nil
        }
  defstruct val: 0, next: nil
end

defmodule Helper do
  def genlist([]), do: nil
  def genlist([hd | tl]) do
    %ListNode{val: hd, next: genlist(tl)}
  end

  def delist(nil), do: []
  def delist(%ListNode{val: v, next: n}) do
    [v | delist(n)] |> Enum.reject(& &1==nil)
  end
end

defmodule Solution do
  defp list_length(node), do: list_length(node, 0)
  defp list_length(node, len) when node == nil, do: len
  defp list_length(node, len) do
    list_length(node.next, len+1)
  end

  defp pop_from_end(node, current, target) when current == target do
    case node.next do
      nil -> nil
      next_node -> %ListNode{val: next_node.val, next: next_node.next}
    end
  end
  defp pop_from_end(node, current, target) do
    %ListNode{val: node.val, next: pop_from_end(node.next, current+1, target)}
  end

  @spec remove_nth_from_end(head :: ListNode.t | nil, n :: integer) :: ListNode.t | nil
  def remove_nth_from_end(head, n) do
    pop_from_end(head, 0, list_length(head) - n)
  end
end

tests = [
  %{input: %{head: [1,2,3,4,5], n: 2}, expect: [1,2,3,5]},
  %{input: %{head: [1], n: 1}, expect: []},
  %{input: %{head: [1,2], n: 1}, expect: [1]},
]

for %{input: %{head: head, n: n}, expect: expect} <- tests do
  Solution.remove_nth_from_end(head |> Helper.genlist, n)
  |> Helper.delist
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
