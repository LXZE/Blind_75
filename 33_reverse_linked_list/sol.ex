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
  @spec reverse_list(head :: ListNode.t | nil) :: ListNode.t | nil
  def reverse_list(nil), do: nil
  def reverse_list(%ListNode{val: v, next: n}), do: reverse_list(n, %ListNode{val: v, next: nil})
  def reverse_list(%ListNode{val: v, next: n}, acc), do: reverse_list(n, %ListNode{val: v, next: acc})
  def reverse_list(nil, acc), do: acc
end

tests = [
  %{input: [1,2,3,4,5], expect: [5,4,3,2,1]},
  %{input: [1,2], expect: [2,1]},
  %{input: [], expect: []},
]

for %{input: nums, expect: expect} <- tests do
  Solution.reverse_list(Helper.genlist(nums))
  |> Helper.delist
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
