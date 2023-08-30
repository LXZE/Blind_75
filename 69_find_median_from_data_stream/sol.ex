defmodule Heap do
  defstruct data: nil, size: 0, comparator: nil

  @type t :: %Heap{
          data: tuple() | nil,
          size: non_neg_integer(),
          comparator: :> | :< | (any(), any() -> boolean())
        }

  @spec min :: t
  def min, do: Heap.new(:<)
  @spec max :: t
  def max, do: Heap.new(:>)

  @spec new :: t
  def new, do: %Heap{comparator: :<}

  @spec new(:> | :< | (any, any -> boolean)) :: t
  def new(:<), do: %Heap{comparator: :<}
  def new(:>), do: %Heap{comparator: :>}

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

  @spec split(t) :: {any, t}
  def split(%Heap{} = heap), do: {Heap.root(heap), Heap.pop(heap)}

  defp meld(nil, queue, _), do: queue
  defp meld(queue, nil, _), do: queue

  defp meld({k0, l0}, {k1, _} = r, :<) when k0 < k1, do: {k0, [r | l0]}
  defp meld({_, _} = l, {k1, r0}, :<), do: {k1, [l | r0]}

  defp meld({k0, l0}, {k1, _} = r, :>) when k0 > k1, do: {k0, [r | l0]}
  defp meld({_, _} = l, {k1, r0}, :>), do: {k1, [l | r0]}

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

defmodule MedianFinder do
  use GenServer

  @impl true
  def init(_), do: {:ok, {Heap.max, Heap.min}}

  @impl true
  def handle_cast({:add_number, number}, {lo_heap, hi_heap}) do
    new_heaps = if lo_heap.size == 0 or Heap.root(lo_heap) > number do
      {Heap.push(lo_heap, number), hi_heap}
    else
      {lo_heap, Heap.push(hi_heap, number)}
    end
    {new_lo_heap, new_hi_heap} = new_heaps

    new_heaps = cond do
      (new_lo_heap.size - new_hi_heap.size) == 2 ->
        {item, new_lo_heap} = Heap.split(new_lo_heap)
        {new_lo_heap, Heap.push(new_hi_heap, item)}
      new_hi_heap.size > new_lo_heap.size ->
        {item, new_hi_heap} = Heap.split(new_hi_heap)
        {Heap.push(new_lo_heap, item), new_hi_heap}
      true -> {new_lo_heap, new_hi_heap}
    end
    {:noreply, new_heaps}
  end

  @impl true
  def handle_call({:find_median}, _, {lo_heap, hi_heap} = heaps) do
    median = if lo_heap.size == hi_heap.size do
      (Heap.root(lo_heap) + Heap.root(hi_heap)) / 2
    else
      Heap.root(lo_heap)
    end
    {:reply, median, heaps}
  end

  @spec init_() :: any
  def init_() do
    with {:error, {:already_started, pid}} <-
        GenServer.start_link(__MODULE__, nil, name: __MODULE__) do
      :ok = GenServer.stop(pid)
      init_()
    end
    nil
  end

  @spec add_num(num :: integer) :: any
  def add_num(num) do
    GenServer.cast(__MODULE__, {:add_number, num}); nil
  end

  @spec find_median() :: float
  def find_median() do
    GenServer.call(__MODULE__, {:find_median})
  end
end

null = nil
tests = [
  %{input: {
    ["MedianFinder", "addNum", "addNum", "findMedian", "addNum", "findMedian"],
    [[], [1], [2], [], [3], []]
  }, expect: [null, null, null, 1.5, null, 2.0]},
  %{input: {
    ["MedianFinder", "addNum", "findMedian"],
    [[], [1], []]
  }, expect: [null, null, 1]},
]

for %{input: {cmds, args}, expect: expects} <- tests do
  Enum.zip([cmds, args, expects])
  |> Enum.map(fn {cmd, arg, expect} ->
    case cmd do
      "MedianFinder" -> MedianFinder.init_()
      _ -> apply(MedianFinder, String.to_atom(Macro.underscore(cmd)), arg)
    end
    |> (&[result: &1, expect: expect, correct?: &1==expect]).()
  end)
end
|> dbg
# |> dbg(limit: :infinity)
