defmodule Day3 do
  @moduledoc """
  --- Day 3: Toboggan Trajectory ---
  Part1 -> how many trees would you encounter, while traversing the map, with (3, 1) slope.
  Part2 -> What do you get if you multiply together the number of
    trees encountered on each of the listed slopes?
  """

  @num_of_rows 323
  @row_length 31

  def solve_part1 do
    airport_map_list = generate_airport_map_list()

    slope1 = %{x: 1, y: 3}
    slope1_trees = find_num_trees(airport_map_list, slope1.x, slope1.y, slope1)

    slope1_trees
  end

  def solve_part2 do
    airport_map_list = generate_airport_map_list()

    slope1 = %{x: 1, y: 1}
    slope1_trees = find_num_trees(airport_map_list, slope1.x, slope1.y, slope1)

    slope2 = %{x: 1, y: 3}
    slope2_trees = find_num_trees(airport_map_list, slope2.x, slope2.y, slope2)

    slope3 = %{x: 1, y: 5}
    slope3_trees = find_num_trees(airport_map_list, slope3.x, slope3.y, slope3)

    slope4 = %{x: 1, y: 7}
    slope4_trees = find_num_trees(airport_map_list, slope4.x, slope4.y, slope4)

    slope5 = %{x: 2, y: 1}
    slope5_trees = find_num_trees(airport_map_list, slope5.x, slope5.y, slope5)

    slope1_trees * slope2_trees * slope3_trees * slope4_trees * slope5_trees
  end

  defp generate_airport_map_list do
    File.stream!("airport_map.txt")
    |> Enum.map(&String.trim/1)
  end

  defp find_num_trees(airport_map_list, row_index, col_index, slope, num_trees \\ 0)
  defp find_num_trees(_airport_map_list, row_index, _col_index, _slope, num_trees)
    when row_index >= @num_of_rows, do: num_trees

  defp find_num_trees(airport_map_list, row_index, col_index, slope, num_trees) do
    ground_point = Enum.at(airport_map_list, row_index)
    |> String.at(rem(col_index, @row_length))
    case ground_point do
      "#" -> find_num_trees(airport_map_list, row_index + slope.x, col_index + slope.y, slope, num_trees + 1)
      "." -> find_num_trees(airport_map_list, row_index + slope.x, col_index + slope.y, slope, num_trees)
    end
  end
end
