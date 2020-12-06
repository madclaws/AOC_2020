defmodule Day2 do
  @moduledoc """
  --- Day 2: Password Philosophy ---
  Part1 -> How many passwords are valid according to sled rental policy?
  Part1 -> How many passwords are valid according to toboggan policiy?
  """

  def solve_part1 do
    generate_password_and_policy_list()
    |> Enum.filter(&is_valid_sled_rental?/1)
    |> Enum.count()
  end

  def solve_part2 do
    generate_password_and_policy_list()
    |> Enum.filter(&is_valid_toboggan?/1)
    |> Enum.count()
  end

  defp generate_password_and_policy_list do
    File.stream!("password_policy.txt")
    |> Enum.map(&String.trim/1)
  end

  defp is_valid_sled_rental?(policy) do
    [limits, keyword, password] = String.split(policy, " ")
    [low_limit, high_limit] = String.split(limits, "-")
    key = String.trim(keyword, ":")
    key_count = password |> String.split("") |> Enum.count(fn char -> char === key end)
    if key_count >= String.to_integer(low_limit) and key_count <= String.to_integer(high_limit) do
      true
    else
      false
    end
  end

  def is_valid_toboggan?(policy) do
    [positions, keyword, password] = String.split(policy, " ")
    [pos1, pos2] = String.split(positions, "-") |> Enum.map(&String.to_integer/1)
    key = String.trim(keyword, ":")
    cond do
      String.at(password, pos1 - 1) === key and String.at(password, pos2 - 1) === key -> false
      String.at(password, pos1 - 1) !== key and String.at(password, pos2 - 1) !== key -> false
      true -> true
    end
  end
end
