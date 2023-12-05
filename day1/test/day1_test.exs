defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "adding calibration values" do
    input = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

    assert Day1.sum_of_calibration_values(input) == 281
  end
end
