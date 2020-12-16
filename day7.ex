defmodule Day7 do
  @moduledoc """
  --- Day 7: Handy Haversacks ---
  Part1: How many bag colors can eventually contain
  at least one shiny gold bag?

  Part2: How many individual bags are required inside your single shiny gold bag?
  """

  def solve_part1 do
    bag_list = generate_data_from_input()
    |> prepare_map_data()
    |> Map.to_list()

    list_of_parent_bags(bag_list, bag_list)
    |> Enum.uniq() |> Enum.count()
  end

  def solve_part2 do

  end

  def list_of_parent_bags(bag_list, bag_ref_list, bag_name \\ "shiny gold", parent_bags \\ [])
  def list_of_parent_bags([], _bag_ref_list, _bag_name, parent_bags), do: parent_bags

  def list_of_parent_bags([h | t], bag_ref_list, bag_name, parent_bags) do
    {parent_bag, child_bags} = h
    case Map.has_key?(child_bags, bag_name) do
      true -> # IO.puts(inspect parent_bag <> " || " <> bag_name)
        list_of_parent_bags(t, bag_ref_list, bag_name, list_of_parent_bags(bag_ref_list,
      bag_ref_list, parent_bag, [parent_bag | parent_bags]))
      _ -> list_of_parent_bags(t, bag_ref_list, bag_name, parent_bags)
    end
  end

  def generate_data_from_input do
    File.stream!("bag_rules.txt")
    |> Enum.map(&String.trim/1)
  end

  def prepare_map_data(bag_rules, map_data \\ %{})
  def prepare_map_data([], map_data), do: map_data
  def prepare_map_data([h | t], map_data) do
    map_data = process_each_line(h, map_data)
    prepare_map_data(t, map_data)
  end

  def process_each_line(line, map_data) do
    [parent, children] = String.split(line, "bags contain") |> Enum.map(&String.trim/1)
    child_map = children |> String.split(",") |> Enum.map(&String.trim/1)
    |> Enum.reduce(%{}, fn data, child_map ->
        [filtered_data, _] = String.trim(data) |> String.trim_trailing(".") |> String.split("bag")
        filtered_list = filtered_data |> String.split(" ") |> Enum.map(&String.trim/1)
        num = List.first(filtered_list)
        case num === "no" do
          true -> child_map
          _ -> Map.put(child_map, String.slice(filtered_data, 1, String.length(filtered_data)) |> String.trim, String.to_integer(num))
        end
      end)
    Map.put(map_data, parent, child_map)
  end
end
