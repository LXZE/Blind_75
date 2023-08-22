defmodule Trie do
  use GenServer

  defmodule TrieCore do
    @opaque trie() :: %{
      optional(char()) => trie(),
      optional(:leaf) => true
    }

    def new(), do: %{}

    def insert(trie, ""), do: Map.put_new(trie, :leaf, true)
    def insert(trie, <<char, rest::binary>>) do
      sub = Map.get(trie, char, %{})
      Map.put(trie, char, insert(sub, rest))
    end

    def member?(trie, ""), do: Map.has_key?(trie, :leaf)
    def member?(trie, <<char, rest::binary>>) do
      case Map.get(trie, char) do
        nil -> false
        sub -> member?(sub, rest)
      end
    end

    def starts_with?(_, ""), do: true
    def starts_with?(trie, <<c, rest::binary>>) do
      case Map.get(trie, c) do
        nil -> false
        sub -> starts_with?(sub, rest)
      end
    end
  end

  @impl true
  def init(_), do: {:ok, TrieCore.new()}

  @impl true
  def handle_cast({:insert, word}, trie) do
    {:noreply, TrieCore.insert(trie, word)}
  end

  @impl true
  def handle_call({func, word}, _, trie) do
    {:reply, apply(TrieCore, func, [trie, word]), trie}
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

  @spec insert(word :: String.t) :: any
  def insert(word) do
    GenServer.cast(__MODULE__, {:insert, word}); nil
  end

  @spec search(word :: String.t) :: boolean
  def search(word) do
    GenServer.call(__MODULE__, {:member?, word})
  end

  @spec starts_with(prefix :: String.t) :: boolean
  def starts_with(prefix) do
    GenServer.call(__MODULE__, {:starts_with?, prefix})
  end
end

null = nil
tests = [
  %{input: {
    ["Trie","insert","search","search","startsWith","insert","search"],
    [[],["apple"],["apple"],["app"],["app"],["app"],["app"]]
  }, expect: [null, null, true, false, true, null, true]},
]

for %{input: {cmds, args}, expect: expects} <- tests do
  Enum.zip([cmds, args, expects])
  |> Enum.map(fn {cmd, arg, expect} ->
    case cmd do
      "Trie"  -> Trie.init_()
      _       -> apply(Trie, String.to_atom(Macro.underscore(cmd)), arg)
    end
    |> (&[result: &1, expect: expect, correct?: &1==expect]).()
  end)
end
|> dbg
# |> dbg(limit: :infinity)
