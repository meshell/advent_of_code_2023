defmodule Day4 do
  @moduledoc """
  Documentation for Day4.
  """

  @doc """
  Parse card
  ## Examples
    iex> "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53" |> Day4.parse_card()
    [[1], [41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53]]
  """
  def parse_card(input) do
    Regex.replace(~r/Card /, input, "")
    |> String.split([":", "|"], trim: true)
    |> Enum.map(fn x -> String.split(x, " ", trim: true) end)
    |> Enum.map(fn x -> Enum.map(x, fn x -> String.to_integer(x) end) end)
  end

  @doc """
  Parse cards
  ## Examples
    iex> "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\\nCard 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19" |> Day4.parse_cards()
    [[[1], [41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53]], [[2], [13, 32, 20, 16, 61], [61, 30, 68, 82, 17, 32, 24, 19]]]
  """
  def parse_cards(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&parse_card/1)
  end

  defp caclulate_points(0), do: 0
  defp caclulate_points(cards), do: Integer.pow(2, cards - 1)

  @doc """
  Parse cards
  ## Examples
    iex> "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\\nCard 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19" |> Day4.card_wining_numbers()
    [[[1], 8], [[2], 2]]
  """
  def card_wining_numbers(input) do
    parse_cards(input)
    |> Enum.map(fn x ->
      [
        Enum.at(x, 0),
        caclulate_points(
          Enum.count(Enum.at(x, 2), fn y ->
            Enum.find_index(Enum.at(x, 1), fn z -> z == y end) != nil
          end)
        )
      ]
    end)
  end

  def caclulate_scratchcard_points(input) do
    card_wining_numbers(input)
    |> Enum.map(fn x -> Enum.at(x, 1) end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  def main(args) do
    {options, _, _} = OptionParser.parse(args, strict: [part: :integer])

    case options do
      [part: 2] ->
        true

      _ ->
        caclulate_scratchcard_points(Input.get_input()) |> IO.inspect()
    end
  end
end
