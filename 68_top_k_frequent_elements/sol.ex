defmodule Heap do
  defstruct data: nil, size: 0, comparator: nil

  @type t :: %Heap{
          data: tuple() | nil,
          size: non_neg_integer(),
          comparator: :> | :< | (any(), any() -> boolean())
        }

  @spec min :: t
  def min, do: Heap.new(:<)

  @spec new :: t
  def new, do: %Heap{comparator: :<}

  @spec new(:> | :< | (any, any -> boolean)) :: t
  def new(:<), do: %Heap{comparator: :<}

  @spec push(t, any()) :: t
  def push(%Heap{data: h, size: n, comparator: d}, value),
    do: %Heap{data: meld(h, {value, []}, d), size: n + 1, comparator: d}

  @spec pop(t) :: t | nil
  def pop(%Heap{data: nil, size: 0} = _heap), do: nil

  def pop(%Heap{data: {_, q}, size: n, comparator: d} = _heap),
    do: %Heap{data: pair(q, d), size: n - 1, comparator: d}

  @spec root(t) :: any()
  def root(%Heap{data: {v, _}} = _heap), do: v
  def root(%Heap{data: nil, size: 0} = _heap), do: nil

  defp meld(nil, queue, _), do: queue
  defp meld(queue, nil, _), do: queue

  defp meld({k0, l0}, {k1, _} = r, :<) when k0 < k1, do: {k0, [r | l0]}
  defp meld({_, _} = l, {k1, r0}, :<), do: {k1, [l | r0]}

  defp pair([], _), do: nil
  defp pair([q], _), do: q

  defp pair([q0, q1 | q], d) do
    q2 = meld(q0, q1, d)
    meld(q2, pair(q, d), d)
  end
end

defimpl Enumerable, for: Heap do
  @spec count(Heap.t()) :: {:ok, non_neg_integer}
  def count(heap) do
    {:ok, Heap.size(heap)}
  end

  @spec member?(Heap.t(), term) :: {:ok, boolean}
  def member?(heap, value) do
    {:ok, Heap.member?(heap, value)}
  end

  def slice(_), do: nil

  @spec reduce(Heap.t(), Enumerable.acc(), Enumerable.reducer()) :: Enumerable.result()
  def reduce(_, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(heap, {:cont, acc}, fun) do
    case Heap.root(heap) do
      nil -> {:done, acc}
      root ->
        heap = Heap.pop(heap)
        reduce(heap, fun.(root, acc), fun)
    end
  end
end

defmodule Solution do
  @spec top_k_frequent(nums :: [integer], k :: integer) :: [integer]
  def top_k_frequent(nums, k) do
    Enum.frequencies(nums)
    |> Enum.reduce(Heap.min, fn {val, size}, heap ->
      new_heap = Heap.push(heap, {size, val})
      if new_heap.size > k, do: Heap.pop(new_heap), else: new_heap
    end)
    |> Enum.map(&elem(&1, 1)) |> Enum.sort
  end
end

tests = [
  %{input: %{nums: [1,1,1,2,2,3], k: 2}, expect: [1,2]},
  %{input: %{nums: [1], k: 1}, expect: [1]},
]

for %{input: %{nums: nums, k: k}, expect: expect} <- tests do
  Solution.top_k_frequent(nums, k)
  |> (&[result: &1, expect: expect, correct?: Enum.sort(&1)==Enum.sort(expect)]).()
end
|> dbg
# |> dbg(limit: :infinity)
