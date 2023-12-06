defmodule Day2 do
  @moduledoc """
  Solution for day 2 of advent of code
  """

  @doc """
  Read lines in chunks seperated by blank line.
  ## Examples

    iex> "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\\nGame 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue" |> Day2.group_input()
    ["Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green", "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue"]
  """
  def group_input(input) do
    input
    |> String.split("\n", trim: true)
  end

  @doc """
  Parse game
  ## Examples

    iex> "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green" |> Day2.parse_game()
    [1, [[{3, "blue"}, {4, "red"}], [{1, "red"}, {2, "green"}, {6, "blue"}], [{2, "green"}]]]
  """
  def parse_game(input) do
    [h | tail] = String.split(input, ":", trim: true)
    id = String.to_integer(String.trim(Regex.replace(~r/Game/, h, "")))

    game =
      String.split(Enum.at(tail, 0), ";", trim: true)
      |> Enum.map(fn x -> String.split(String.trim(x), ",", trim: true) end)
      |> Enum.map(fn x ->
        Enum.map(x, fn x2 -> String.split(String.trim(x2), " ", trim: true) end)
      end)
      |> Enum.map(fn x ->
        Enum.map(x, fn x2 -> {String.to_integer(Enum.at(x2, 0)), Enum.at(x2, 1)} end)
      end)

    [id, game]
  end

  defp is_valid({no_cubes, color}, {no_all_cubes, filter_color}) when color == filter_color do
    no_cubes <= no_all_cubes
  end

  defp is_valid({_, _}, {_, _}) do
    true
  end

  @doc """
  Check draw is valid game
  ## Examples

    iex> Day2.draw_is_valid({9, "red"}, [{10, "red"}, {10, "green"}, {10, "blue"}])
    true
    iex> Day2.draw_is_valid({11, "red"}, [{10, "red"}, {10, "green"}, {10, "blue"}])
    false
    iex> Day2.draw_is_valid({12, "green"}, [{10, "red"}, {10, "green"}, {10, "blue"}])
    false
    iex> Day2.draw_is_valid({10, "red"}, [{10, "red"}, {10, "green"}, {10, "blue"}])
    true
  """
  def draw_is_valid(draw, filter) do
    Enum.all?(filter, fn f -> is_valid(draw, f) end)
  end

  @doc """
  Set is valid
  ## Examples

    iex> Day2.set_is_valid([{9, "red"}, {9, "green"}, {9, "blue"}], [{10, "red"}, {10, "green"}, {10, "blue"}])
    true
    iex> Day2.set_is_valid([{9, "red"}, {11, "green"}, {9, "blue"}], [{10, "red"}, {10, "green"}, {10, "blue"}])
    false
    iex> Day2.set_is_valid([{11, "red"}, {8, "green"}, {9, "blue"}], [{10, "red"}, {10, "green"}, {10, "blue"}])
    false
    iex> Day2.set_is_valid([{9, "red"}, {7, "green"}, {12, "blue"}], [{10, "red"}, {10, "green"}, {10, "blue"}])
    false
    iex> Day2.set_is_valid([{9, "red"}, {9, "blue"}], [{10, "red"}, {10, "green"}, {10, "blue"}])
    true
    iex> Day2.set_is_valid([{13, "red"}], [{10, "red"}, {10, "green"}, {10, "blue"}])
    false
  """
  def set_is_valid(set, filter) do
    Enum.all?(set, fn x -> draw_is_valid(x, filter) end)
  end

  @doc """
  Game is valid
  ## Examples

  iex> [1, [[{3, "blue"}, {4, "red"}], [{1, "red"}, {2, "green"}, {6, "blue"}], [{2, "green"}]]] |> Day2.game_is_valid([{10, "red"}, {10, "green"}, {10, "blue"}])
  [1, true]
  iex> [1, [[{3, "blue"}, {4, "red"}], [{1, "red"}, {12, "green"}, {6, "blue"}], [{2, "green"}]]] |> Day2.game_is_valid([{10, "red"}, {10, "green"}, {10, "blue"}])
  [1, false]
  """
  def game_is_valid([game_id, game], filter) do
    [game_id, Enum.all?(game, fn x -> set_is_valid(x, filter) end)]
  end

  @doc """
  Get valid games 
  ## Examples

  iex> "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\\nGame 2: 1 blue, 12 green; 3 green, 4 blue, 1 red; 1 green, 1 blue\\nGame 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue" |> Day2.parse_games([{10, "red"}, {10, "green"}, {10, "blue"}])
  [[1, true], [2, false], [2, true]]

  """
  def parse_games(input, filter) do
    group_input(input)
    |> Enum.map(fn x -> parse_game(x) end)
    |> Enum.map(fn x -> game_is_valid(x, filter) end)
  end

  defp get_id_value([id, true]), do: id
  defp get_id_value([_, false]), do: 0

  @doc """
  Part 1
  Determines which games would have been possible if the bag had been loaded in filter and calculates the sum of the IDs of those games.
  """
  def sum_ids_valid_games(input, filter) do
    parse_games(input, filter)
    |> Enum.reduce(0, fn x, acc -> acc + get_id_value(x) end)
  end

  defp set_minimal({v, color}, {minimal, cube_color}) when color == cube_color do
    cond do
      v > minimal -> {v, cube_color}
      true -> {minimal, cube_color}
    end
  end

  defp set_minimal({_, _}, {minimal, cube_color}) do
    {minimal, cube_color}
  end

  @doc """
  Get minimal number of cubes for game
  ## Examples

  iex> [1, [[{3, "blue"}, {4, "red"}], [{1, "red"}, {2, "green"}, {6, "blue"}], [{2, "green"}]]] |> Day2.minimal_number_cubes_for_game()
  [1, [{4, "red"}, {2, "green"}, {6, "blue"}]]

  """
  def minimal_number_cubes_for_game([game_id, game]) do
    red =
      Enum.map(game, fn set ->
        Enum.reduce(set, {0, "red"}, fn x, acc -> set_minimal(x, acc) end)
      end)
      |> Enum.reduce(fn x, acc -> set_minimal(x, acc) end)

    green =
      Enum.map(game, fn set ->
        Enum.reduce(set, {0, "green"}, fn x, acc -> set_minimal(x, acc) end)
      end)
      |> Enum.reduce(fn x, acc -> set_minimal(x, acc) end)

    blue =
      Enum.map(game, fn set ->
        Enum.reduce(set, {0, "blue"}, fn x, acc -> set_minimal(x, acc) end)
      end)
      |> Enum.reduce(fn x, acc -> set_minimal(x, acc) end)

    [game_id, [red, green, blue]]
  end

  @doc """
  Calculate the power of minal cubes
  ## Examples

  iex> [1, [{4, "red"}, {2, "green"}, {6, "blue"}]] |> Day2.power_of_minimal_cubes()
  [1, 48]

  """
  def power_of_minimal_cubes([game_id, minimals]) do
    [game_id, Enum.reduce(minimals, 1, fn {x, _}, acc -> x * acc end)]
  end

  @doc """
  Part 2
  Find for each game the minimum set of cubes that must have been present and calculates the sum of the power of these sets?
  """
  def sum_of_power_minimal_cube_set(input) do
    group_input(input)
    |> Enum.map(fn x -> parse_game(x) end)
    |> Enum.map(fn x -> minimal_number_cubes_for_game(x) end)
    |> Enum.map(fn x -> power_of_minimal_cubes(x) end)
    |> Enum.reduce(0, fn [_, pow], acc -> pow + acc end)
  end

  def main(args) do
    {options, _, _} = OptionParser.parse(args, strict: [part: :integer])

    case options do
      [part: 1] ->
        sum_ids_valid_games(Input.get_input(), [{12, "red"}, {13, "green"}, {14, "blue"}])
        |> IO.inspect()

      _ ->
        sum_of_power_minimal_cube_set(Input.get_input()) |> IO.inspect()
    end
  end
end
