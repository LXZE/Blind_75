defmodule Solution do
  def check(l, r, str) when l > r, do: true
  def check(l, r, str) do
    if elem(str, l) == elem(str, r), do: check(l+1, r-1, str),
    else: false
  end

  @spec is_palindrome(s :: String.t) :: boolean
  def is_palindrome(s) do
    str = String.downcase(s)
    |> String.replace(~r/[^[:alnum:]]/, "")
    |> String.codepoints

    check(0, length(str) - 1, List.to_tuple(str))
  end
end

tests = [
  %{input: "A man, a plan, a canal: Panama", expect: true},
  %{input: "race a car", expect: false},
  %{input: " ", expect: true},
  %{input: "0P", expect: false},
]

for %{input: strs, expect: expect} <- tests do
  Solution.is_palindrome(strs)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
