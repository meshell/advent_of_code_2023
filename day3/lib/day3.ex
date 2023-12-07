defmodule Day3 do
  @moduledoc """
  Solution for day 3 of advent of code 2023
  """

  @doc """
  Read lines in chunks seperated by blank line.
  ## Examples

    iex> Day3.is_symbol("*")
    true
    iex> Day3.is_symbol("/")
    true
    iex> Day3.is_symbol("&")
    true
    iex> Day3.is_symbol("#")
    true
    iex> Day3.is_symbol("@")
    true
    iex> Day3.is_symbol(".")
    false
    iex> Day3.is_symbol("1")
    false
  """
  def is_symbol("."), do: false
  def is_symbol("-"), do: true
  def is_symbol(" "), do: false
  def is_symbol("\n"), do: false

  def is_symbol(x) do
    cond do
      Integer.parse(x) == :error -> true
      true -> false
    end
  end

  def is_digit("-") do
    ""
  end

  def is_digit(x) do
    cond do
      Integer.parse(x) != :error -> x
      true -> ""
    end
  end

  defp set_prev(char, prev) do
    if is_digit(char) == "", do: is_digit(char), else: prev <> is_digit(char)
  end

  defp set_number(char, prev) do
    if is_digit(char) == "", do: prev, else: ""
  end

  defp set_length(char, l) do
    if is_digit(char) != "", do: l + 1, else: 0
  end

  defp set_start_x("\n", _, _) do
    0
  end

  defp set_start_x(char, start_x, x) do
    if is_digit(char) != "", do: start_x, else: x + 1
  end

  defp set_y(cur, "\n") do
    cur + 1
  end

  defp set_y(cur, _) do
    cur
  end

  defp set_x(_, "\n") do
    0
  end

  defp set_x(_, " ") do
    0
  end

  defp set_x(cur, _) do
    cur + 1
  end

  @doc """
  Find and encode symbols
  Return a  list of coordinates [x, y] (with x: column, y: row) where symbols are located
  ## Examples

    iex> "467..114..\\n...*......\\n..35..633.\\n......#..." |> Day3.parse_symbols()
    [[3, 1], [6, 3]]
    iex> "12.......*.." |> Day3.parse_symbols()
    [[9, 0]]
  """
  def parse_symbols(input) do
    String.codepoints(input)
    |> Enum.map_reduce({0, 0}, fn char, {x, y} ->
      {[is_symbol(char), [x, y]], {set_x(x, char), set_y(y, char)}}
    end)
    |> Tuple.to_list()
    |> Enum.at(0)
    |> Enum.filter(fn [b, _] -> b end)
    |> Enum.map(fn [_, coord] -> coord end)
  end

  @doc """
  Find and encode symbols
  Return a  list of coordinates [x, y] (with x: column, y: row) where symbols are located
  ## Examples

    iex> "12.......*..\\n.+.........34\\n.......-12.." |> Day3.parse_numbers()
    [{"12", [0, 0, 2]}, {"34", [11, 1, 2]}, {"12", [8, 2, 2]}]
  """
  def parse_numbers(input) do
    String.codepoints(input)
    |> Enum.map_reduce({"", 0, 0, 0, 0}, fn char, {prev, start_x, cur_x, cur_y, len} ->
      {{set_number(char, prev), [start_x, cur_y, len]},
       {set_prev(char, prev), set_start_x(char, start_x, cur_x), set_x(cur_x, char),
        set_y(cur_y, char), set_length(char, len)}}
    end)
    |> Tuple.to_list()
    |> Enum.at(0)
    |> Enum.filter(fn {x, _} -> x != "" end)
  end

  @doc """
  Is adjacent 
  ## Examples
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [1, 0])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [2, 0])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [3, 0])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [4, 0])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [5, 0])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [1, 2])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [2, 2])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [3, 2])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [4, 2])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [5, 2])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [1, 1])
    true
    iex> Day3.is_adjacent({"467", [2, 1, 3]}, [5, 1])
    true
    iex> Day3.is_adjacent({"4", [2, 1, 1]}, [1, 3])
    false
    iex> Day3.is_adjacent({"4", [3, 1, 1]}, [1, 1])
    false
    iex> Day3.is_adjacent({"4", [3, 1, 1]}, [5, 1])
    false
  """
  def is_adjacent(number, [x, y]) do
    {_, [start_x, start_y, l]} = number

    cond do
      y >= start_y - 1 and y <= start_y + 1 and x >= start_x - 1 and x <= start_x + l -> true
      true -> false
    end
  end

  @doc """
  Find part numbers
  """
  def find_part_numbers(input) do
    symbols = parse_symbols(input)

    parse_numbers(input)
    |> Enum.filter(fn x -> Enum.any?(symbols, fn s -> is_adjacent(x, s) end) end)
    |> Enum.map(fn {n, _} -> String.to_integer(n) end)
  end

  def sum_of_part_numbers(input) do
    find_part_numbers(input)
    |> Enum.sum()
  end

  def main(args) do
    {options, _, _} = OptionParser.parse(args, strict: [part: :integer])

    case options do
      [part: 2] ->
        false

      _ ->
        sum_of_part_numbers(Input.get_input()) |> IO.inspect()
    end
  end
end
