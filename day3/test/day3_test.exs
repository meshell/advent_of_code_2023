defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "find part numbers" do
    input = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598.. 
    """

    assert Day3.find_part_numbers(input) == [467, 35, 633, 617, 592, 755, 664, 598]
  end

  test "find part numbers with difficult input" do
    input = """
    12.......*..
    +.........34
    .......-12..
    ..78........
    ..*....60...
    78.........9
    .5.....23..$
    8...90*12...
    ............
    2.2......12.
    .*.........*
    1.1..503+.56
    """

    assert Day3.find_part_numbers(input) == [
             12,
             34,
             12,
             78,
             78,
             9,
             23,
             90,
             12,
             2,
             2,
             12,
             1,
             1,
             503,
             56
           ]
  end

  test "sum of all of the part numbers" do
    input = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598.. 
    """

    assert Day3.sum_of_part_numbers(input) == 4361
  end

  test "sum of all of the part numbers with difficult input" do
    input = """
    12.......*..
    +.........34
    .......-12..
    ..78........
    ..*....60...
    78.........9
    .5.....23..$
    8...90*12...
    ............
    2.2......12.
    .*.........*
    1.1..503+.56
    """

    assert Day3.sum_of_part_numbers(input) == 925
  end
end
