defmodule Solution do
  defp create_counter(str) do
    String.codepoints(str)
    |> Enum.frequencies
  end

  @spec is_anagram(s :: String.t, t :: String.t) :: boolean
  def is_anagram(s, t) do
    create_counter(s) == create_counter(t)
  end
end

tests = [
  %{input: %{s: "anagram", t: "nagaram"}, expect: true},
  %{input: %{s: "rat", t: "car"}, expect: false},
]

for %{input: %{s: s, t: t}, expect: expect} <- tests do
  Solution.is_anagram(s, t)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
