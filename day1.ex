defmodule Day1 do
  @moduledoc """
    Day 1: Report Repair
    --------------------
    Part1: Find the multiple of 2 numbers, that will add upto 2020, from the expense report.
    Part2: Find the multiple of 3 numbers, that will add upto 2020, from the expense report.
  """

  def solve_part1 do
    generate_expense_list()
    |> get_product_of_two()
  end

  def solve_part2 do
    generate_expense_list()
    |> get_product_of_three()
  end

  defp get_product_of_two(expense_list) do
    for a <- expense_list, b <- expense_list, Enum.sum([a, b]) === 2020 do
      a * b
    end
    |> List.first()
  end

  defp get_product_of_three(expense_list) do
    for a <- expense_list, b <- expense_list, c <- expense_list, Enum.sum([a, b, c]) === 2020 do
      a * b * c
    end
    |> List.first()
  end


  defp generate_expense_list do
    File.stream!("expense_report.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end
end
