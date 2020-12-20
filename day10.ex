defmodule Day10 do
  @moduledoc """
  --- Day 10: Adapter Array ---
  Part1: What is the number of 1-jolt differences multiplied by
  the number of 3-jolt differences?
  """

  def solve_part1 do
    jolt_adapters = generate_jolt_list()
    max_adapter = jolt_adapters |> Enum.max()
    built_in_adapter = max_adapter + 3
    jolt_adapters = [built_in_adapter | jolt_adapters]
    %{1 => diff_1, 3 => diff_2} = Enum.sort(jolt_adapters)
    |> create_diff_map(built_in_adapter)
    diff_1 * diff_2
  end

  def solve_part2 do

  end

  def generate_jolt_list do
    File.stream!("jolt_list.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def create_diff_map(jolt_adapters, built_in, current_source \\ 0, diff_map \\ %{})
  def create_diff_map(_jolt_adapters, built_in, current_source, diff_map) when
   built_in === current_source, do: diff_map
  def create_diff_map(jolt_adapters, built_in, current_source, diff_map) do
    accepted_adapter = find_accepted_adapter(current_source, jolt_adapters)
    diff = accepted_adapter - current_source
    create_diff_map(jolt_adapters, built_in, accepted_adapter, Map.update(diff_map, diff, 1, &(&1 + 1)))
  end

  def find_accepted_adapter(current_source, jolt_adapters) do
    [h | _t] = for adapter <- jolt_adapters, (adapter - current_source) <= 3,
      (adapter - current_source) > 0, do: adapter
    h
  end

end
