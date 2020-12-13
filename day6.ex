defmodule Day6 do
  @moduledoc """
  --- Day 6: Custom Customs ---
  Part1: For each group, count the number of questions to which anyone answered "yes".
    What is the sum of those counts?
  Part2: For each group, count the number of questions to which everyone answered "yes".
  What is the sum of those counts?
  """

  def solve_part1 do
    generate_qa_data()
    |> find_sum_of_any()
  end

  def solve_part2 do
    generate_qa_data()
    |> find_sum_of_every()
  end

  def generate_qa_data do
    File.stream!("qa.txt")
    |> Enum.map(&String.trim/1)
  end

  def find_sum_of_any(qa_data, appender \\ "", group_count \\ [])
  def find_sum_of_any([], _appender, group_count), do: Enum.sum(group_count)
  def find_sum_of_any([h | t], appender, group_count) when h === "" do
    unique_count = String.to_charlist(appender)
    |> Enum.uniq() |> Enum.count()
    # IO.puts(inspect unique_count)
    find_sum_of_any(t, "", [unique_count | group_count])
  end

  def find_sum_of_any([h | t], appender, group_count) do
    find_sum_of_any(t, appender <> h, group_count)
  end

  def find_sum_of_every(qa_data, appender \\ "", members \\ 0, group_count \\ [])
  def find_sum_of_every([], _appender, _members, group_count), do: Enum.sum(group_count)
  def find_sum_of_every([h | t], appender, members, group_count) when h === "" do
    unique_count = String.to_charlist(appender)
    |> Enum.frequencies()
    |> Enum.filter(fn {_k, v} -> v === members end) |> Enum.count()
    # IO.puts(inspect unique_count)
    find_sum_of_every(t, "", 0, [unique_count | group_count])
  end

  def find_sum_of_every([h | t], appender, members, group_count) do
    find_sum_of_every(t, appender <> h, members + 1, group_count)
  end

end
