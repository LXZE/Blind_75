defmodule Solution do
  @spec is_valid(s :: String.t) :: boolean
  def is_valid(s) do
    String.codepoints(s)
    |> Enum.reduce_while([], fn
      elem, [] -> {:cont, [elem]}
      elem, [to_check | remain] = acc ->
        cond do
          elem in ["(", "{", "["] -> {:cont, [elem | acc]}
          true ->
            cond do
              {to_check, elem} in [{"(", ")"}, {"{", "}"}, {"[", "]"}]
                -> {:cont, remain}
              true -> {:halt, false}
            end
        end
    end)
    |> (fn
      [] -> true
      _ -> false
    end).()
  end
end

tests = [
  %{input: "()", expect: true},
  %{input: "()[]{}", expect: true},
  %{input: "(]", expect: false},
  %{input: "[]]", expect: false},
]

for %{input: strs, expect: expect} <- tests do
  Solution.is_valid(strs)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
