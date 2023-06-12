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
end

tests = [
  %{input: %{l1: [1,2,4], l2: [1,3,4]}, expect: [1,1,2,3,4,4]},
  %{input: %{l1: [], l2: []}, expect: []},
  %{input: %{l1: [], l2: [0]}, expect: [0]},
]

for %{input: %{l1: l1, l2: l2}, expect: expect} <- tests do
  Solution.merge_two_lists(Helper.genlist(l1),Helper.genlist(l2))
  |> Helper.delist
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
