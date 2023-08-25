defmodule WordDictionary do
  use GenServer

  defmodule Trie do
    defstruct leaf: false, next: %{}
  end

  defmodule Dict do
    def new(), do: %Trie{}

    def add(trie, ""), do: %Trie{trie | leaf: true}
    def add(trie, <<char, tail::binary>>) do
      Map.update(trie.next, char, add(%Trie{}, tail), &add(&1, tail))
      |> (& %Trie{trie | next: &1}).()
    end

    def search(nil, _), do: false
    def search(trie, ""), do: trie.leaf
    def search(trie, <<?., tail::binary>>) do
      Enum.any?(trie.next, fn {_, val} -> search(val, tail) end)
    end
    def search(trie, <<char, tail::binary>>) do
      Map.get(trie.next, char)
      |> search(tail)
    end
  end

  @impl true
  def init(_), do: {:ok, Dict.new()}

  @impl true
  def handle_cast({:add, word}, trie) do
    {:noreply, Dict.add(trie, word)}
  end

  @impl true
  def handle_call({:search, word}, _, trie) do
    {:reply, Dict.search(trie, word), trie}
  end

  @spec init_() :: any
  def init_() do
    with {:error, {:already_started, pid}} <-
        GenServer.start_link(__MODULE__, nil, name: __MODULE__) do
      :ok = GenServer.stop(pid)
      init_()
    end; nil
  end

  @spec add_word(word :: String.t) :: any
  def add_word(word) do
    GenServer.cast(__MODULE__, {:add, word}); nil
  end

  @spec search(word :: String.t) :: boolean
  def search(word) do
    GenServer.call(__MODULE__, {:search, word})
  end
end

null = nil
tests = [
  %{input: {
    ["WordDictionary","addWord","addWord","addWord","search","search","search","search","search","search"],
    [[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."],["b.a"],[".p"]]
  }, expect: [null,null,null,null,false,true,true,true,false,false]},
  %{input: {
    ["WordDictionary","addWord","addWord","search","search","search","search","search","search"],
    [[],["a"],["a"],["."],["a"],["aa"],["a"],[".a"],["a."]]
  }, expect: [null,null,null,true,true,false,true,false,false]},
  %{input: {
    ["WordDictionary","addWord","addWord","addWord","addWord","search","search","addWord","search","search","search","search","search","search"],
    [[],["at"],["and"],["an"],["add"],["a"],[".at"],["bat"],[".at"],["an."],["a.d."],["b."],["a.d"],["."]]
  }, expect: [null,null,null,null,null,false,false,null,true,true,false,false,true,false]},
  %{input: {
    ["WordDictionary","addWord","addWord","search","search","search","search","search","search","search","search"],
    [[],["a"],["ab"],["a"],["a."],["ab"],[".a"],[".b"],["ab."],["."],[".."]]
  }, expect: [null,null,null,true,true,true,false,true,false,true,true]},
]

for %{input: {cmds, args}, expect: expects} <- tests do
  Enum.zip([cmds, args, expects])
  |> Enum.map(fn {cmd, arg, expect} ->
    case cmd do
      "WordDictionary"  -> WordDictionary.init_()
      _       -> apply(WordDictionary, String.to_atom(Macro.underscore(cmd)), arg)
    end
    |> (&[cmd: cmd, arg: arg, result: &1, expect: expect, correct?: &1==expect]).()
  end)
end
|> dbg
# |> dbg(limit: :infinity)
