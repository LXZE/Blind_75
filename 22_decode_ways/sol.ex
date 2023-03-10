defmodule Solution do
  def str_to_int([a, b]), do: String.to_integer(a <> b)

  @spec num_decodings(s :: String.t) :: integer
  def num_decodings("0" <> _), do: 0
  def num_decodings(s) do
    if String.length(s) == 1, do: 1,
    else: (
      lst_s = String.graphemes(s) |> List.to_tuple
      second_pos = elem(lst_s, 1) != "0" && 1 || 0
      for idx <- 2..String.length(s), reduce: {1, second_pos} do
        {prev2, prev1} ->
          current = if elem(lst_s, idx-1) != "0", do: prev1, else: 0
          current = if elem(lst_s, idx-2) != "0" and \
            str_to_int(idx-2..idx-1 |> Enum.map(&elem(lst_s, &1))) <= 26,
            do: current + prev2, else: current
          {prev1, current}
      end
      |> elem(1)
    )
  end
end

tests = [
  %{input: "12", expect: 2},
  %{input: "226", expect: 3},
  %{input: "06", expect: 0},
  %{input: "1", expect: 1},
]

for %{input: n, expect: expect} <- tests do
  Solution.num_decodings(n) |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
