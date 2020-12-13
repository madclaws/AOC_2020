defmodule Day5 do
  @moduledoc """
  --- Day 5: Binary Boarding ---
  Part1: As a sanity check, look through your list of boarding passes.
    What is the highest seat ID on a boarding pass?
  Part2: What is the ID of your seat?
  """

  def solve_part1 do
    generate_boarding_pass_data()
    |> Enum.map(fn boarding_pass -> get_boarding_id(boarding_pass) end)
    |> Enum.max()
  end

  def solve_part2 do
    boarding_ids = generate_boarding_pass_data()
    |> Enum.map(fn boarding_pass -> get_boarding_id(boarding_pass) end)
    max_id = Enum.max(boarding_ids)
    secondary_ids = boarding_ids
    |> Enum.filter(fn id -> id < max_id end)
    |> Enum.map(fn id -> id + 1 end)

    [missing_id] = secondary_ids -- boarding_ids
    missing_id
  end

  def generate_boarding_pass_data() do
    File.stream!("boarding_passes.txt")
    |> Enum.map(&String.trim/1)
  end

  defp get_boarding_id(boarding_pass) do
    find_row(boarding_pass) * 8 + find_column(boarding_pass)
  end

  # lh => lowerhalf, uh => upperhalf
  defp find_row(row_part, index \\ 0, size \\ 128, lh \\ 0, uh \\ 127)
  defp find_row(_row_part, 7, _size, lh, _uh), do: lh
  defp find_row(row_part, index, size, lh, uh) do
    case String.at(row_part, index) do
      "F" -> find_row(row_part, index + 1, div(size, 2), lh, uh - div(size, 2))
       _ ->  find_row(row_part, index + 1, div(size, 2), lh + div(size, 2), uh)
    end
  end

  defp find_column(col_part, index \\ 7, size \\ 8, lh \\ 0, uh \\ 7)
  defp find_column(_col_part, 10, _size, lh, _uh), do: lh
  defp find_column(col_part, index, size, lh, uh) do
    case String.at(col_part, index) do
      "L" -> find_column(col_part, index + 1, div(size, 2), lh, uh - div(size, 2))
       _ ->  find_column(col_part, index + 1, div(size, 2), lh + div(size, 2), uh)
    end
  end

end
