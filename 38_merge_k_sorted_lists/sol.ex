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
  @spec merge_two_lists(list1 :: ListNode.t | nil, list2 :: ListNode.t | nil) :: ListNode.t | nil
  def merge_two_lists(nil, nil), do: nil
  def merge_two_lists(nil, list2), do: list2
  def merge_two_lists(list1, nil), do: list1
  def merge_two_lists(%ListNode{val: v1, next: list1}, list2) when v1 <= list2.val do
    %ListNode{val: v1, next: merge_two_lists(list1, list2)}
  end
  def merge_two_lists(list1, %ListNode{val: v2, next: list2}) do
    %ListNode{val: v2, next: merge_two_lists(list1, list2)}
  end

  @spec merge_k_lists(lists :: [ListNode.t | nil]) :: ListNode.t | nil
  def merge_k_lists(lists) when length(lists) == 0, do: nil
  def merge_k_lists(lists) when length(lists) == 1, do: hd(lists)
  def merge_k_lists(lists) do
    Stream.chunk_every(lists, 2, 2, [nil])
    |> Enum.map(fn [l1, l2] -> merge_two_lists(l1, l2) end)
    |> merge_k_lists
  end
end

tests = [
  %{input: [[1,4,5],[1,3,4],[2,6]], expect: [1,1,2,3,4,4,5,6]},
  %{input: [], expect: []},
  %{input: [[]], expect: []},
]

for %{input: list, expect: expect} <- tests do
  Solution.merge_k_lists(Enum.map(list, &Helper.genlist/1))
  |> Helper.delist
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
