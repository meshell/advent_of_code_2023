defmodule Day1 do
  @moduledoc """
  Solution for day 1 of advent of code
  """

  @doc """
  Read lines in chunks seperated by blank line.
  ## Examples

    iex> "1abc2\\npqr3stu8vwx\\na1b2c3d4e5f\\ntreb7uchet" |> Day1.group_input()
    ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]
  """
  def group_input(input) do
    input
    |> String.split("\n", trim: true)
  end

  @doc """
  Get all digits by startining parsing from front

  ## Examples

    iex> "1a3bc2" |> Day1.getdigits_from_front()
    '132'
    iex> "oneathreebctwo" |> Day1.getdigits_from_front()
    '132'
    iex> "2oneight" |> Day1.getdigits_from_front()
    '21'
  """
  def getdigits_from_front(line_input) do
    translate_map = [
      [~r/two/, "2"],
      [~r/one/, "1"],
      [~r/three/, "3"],
      [~r/four/, "4"],
      [~r/five/, "5"],
      [~r/six/, "6"],
      [~r/seven/, "7"],
      [~r/eight/, "8"],
      [~r/nine/, "9"]
    ]

    String.graphemes(line_input)
    |> Enum.reduce("", fn x, acc ->
      Enum.reduce(translate_map, acc <> x, fn [r, v], acc2 -> Regex.replace(r, acc2, v) end)
    end)
    |> String.to_charlist()
    |> Enum.filter(fn x -> x >= 48 and x < 58 end)
  end

  @doc """
  Get all digits by startining parsing from back

  ## Examples

    iex> "1a3bc2" |> Day1.getdigits_from_back()
    '132'
    iex> "oneathreebctwo" |> Day1.getdigits_from_back()
    '132'
    iex> "2oneight" |> Day1.getdigits_from_back()
    '28'
  """
  def getdigits_from_back(line_input) do
    translate_map = [
      [~r/two/, "2"],
      [~r/one/, "1"],
      [~r/three/, "3"],
      [~r/four/, "4"],
      [~r/five/, "5"],
      [~r/six/, "6"],
      [~r/seven/, "7"],
      [~r/eight/, "8"],
      [~r/nine/, "9"]
    ]

    Enum.reverse(String.graphemes(line_input))
    |> Enum.reduce("", fn x, acc ->
      Enum.reduce(translate_map, x <> acc, fn [r, v], acc2 -> Regex.replace(r, acc2, v) end)
    end)
    |> String.to_charlist()
    |> Enum.filter(fn x -> x >= 48 and x < 58 end)
  end

  @doc """
  Get calibration value
  ## Examples

    iex> "1a3bc2" |> Day1.get_calibration_value()
    12
    iex> "two1nine" |> Day1.get_calibration_value()
    29
    iex> "eightwothree" |> Day1.get_calibration_value()
    83
    iex> "abcone2threexyz" |> Day1.get_calibration_value()
    13    
    iex> "xtwone3four" |> Day1.get_calibration_value()
    24
    iex> "4nineeightseven2" |> Day1.get_calibration_value()
    42
    iex> "zoneight234" |> Day1.get_calibration_value()
    14
    iex> "7pqrstsixteen" |> Day1.get_calibration_value()
    76
    iex> "2oneight" |> Day1.get_calibration_value()
    28
  """
  def get_calibration_value(line_input) do
    Integer.undigits([
      List.first(getdigits_from_front(line_input)) - 48,
      List.last(getdigits_from_back(line_input)) - 48
    ])
  end

  @doc """
    Get sum of all calibration values
    iex> "two1nine\\neightwothree\\nabcone2threexyz\\nxtwone3four\\n4nineeightseven2\\nzoneight234\\n7pqrstsixteen" |> Day1.sum_of_calibration_values()
    281
  """
  def sum_of_calibration_values(input) do
    input
    |> group_input()
    |> Enum.reduce(0, fn x, acc -> get_calibration_value(x) + acc end)
  end

  def main(args) do
    sum_of_calibration_values(Input.get_input()) |> IO.inspect()
  end
end
