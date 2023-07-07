defmodule Solution do
  def create_freq_map(str) do
    String.codepoints(str)
    |> Enum.reduce(Map.new, fn elem, acc ->
      Map.update(acc, elem, 1, & &1+1)
    end)
  end

  def shift_l(l, counter, {char_list, target} = const) do
    key = elem(char_list, l)
    new_counter = Map.update!(counter, key, & &1-1)
    if Map.has_key?(target, key) and Map.get(new_counter, key) < Map.get(target, key)
      do {l+1, new_counter}
      else shift_l(l+1, new_counter, const)
    end
  end

  def min_range(-1..0, r), do: r
  def min_range(l, r) do
    if Range.size(l) < Range.size(r) do l else r end
  end

  @spec min_window(s :: String.t, t :: String.t) :: String.t
  def min_window(s, t) do
    if String.length(s) >= String.length(t) do
      target = create_freq_map(t)
      target_size = Map.keys(target) |> length
      char_list = String.codepoints(s) |> List.to_tuple

      Tuple.to_list(char_list)
      |> Stream.with_index |> Enum.reduce(
        {0, 0, -1..0, Map.new},
        fn {char, r}, {l, window_size, res, counter} ->
          # dbg({char, l, r, window_size, String.slice(s, l..r)})
          new_counter = Map.update(counter, char, 1, & &1+1)
          # if current window met criteria for certain char
          new_window_size =
            if Map.has_key?(new_counter, char)
            and Map.get(new_counter, char) == Map.get(target, char),
            do: window_size + 1, else: window_size
            # if substr met criteria, move l until invalid
            if new_window_size == target_size do
              {new_l, new_counter} = shift_l(l, new_counter, {char_list, target})
              {new_l, new_window_size-1, min_range(res, (new_l-1)..r), new_counter}
            else {l, new_window_size, res, new_counter} end
        end)
      |> elem(2)
      |> (fn
        -1..0 -> ""
        r -> String.slice(s, r)
      end).()
    else "" end
  end
end


big_case_s = File.read!("big_s.txt") |> Code.eval_string |> elem(0)
big_case_t = File.read!("big_t.txt") |> Code.eval_string |> elem(0)
ans = File.read!("ans.txt") |> Code.eval_string |> elem(0)

tests = [
  %{input: %{s: "ADOBECODEBANC", t: "ABC"}, expect: "BANC"},
  %{input: %{s: "a", t: "a"}, expect: "a"},
  %{input: %{s: "a", t: "aa"}, expect: ""},
  %{input: %{s: big_case_s, t: big_case_t}, expect: ans},
  %{input: %{s: "a", t: "b"}, expect: ""},
]

for %{input: %{s: s, t: t}, expect: expect} <- tests do
  Solution.min_window(s, t)
  |> (&[result: &1, expect: expect, correct?: &1==expect]).()
end
|> dbg
# |> dbg(limit: :infinity)
