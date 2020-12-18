defmodule Day9 do
  @moduledoc """
  --- Day 9: Encoding Error ---
  Part 1: first number in the list (after the preamble) which is not the sum of two
    of the 25 numbers before it
  Part 2: To find the encryption weakness, add together the smallest and
    largest number in this contiguous range
  """
  @preamble_length 25

  def solve_part1 do
    generate_xmas_numbers()
    |> find_first_error_num(@preamble_length)
  end

  def solve_part2 do
    xmas_data = generate_xmas_numbers()
    invalid_number = solve_part1()
    contigous_list = get_contigous_list(xmas_data, xmas_data, invalid_number)
    Enum.min(contigous_list) + Enum.max(contigous_list)
  end

  def generate_xmas_numbers do
    File.stream!("xmas_data.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def is_sum_possible(preamble, num) do
    # IO.puts(inspect preamble)
    # IO.puts(inspect num)

    sum_list = for x <- preamble, y <- preamble, x !== y, x + y === num, do: true
    Enum.count(sum_list) > 0
  end

  def find_first_error_num(xmas_data, index, error_num \\ nil)
  def find_first_error_num([], _index, error_num), do: error_num
  def find_first_error_num(xmas_data, index, error_num) do
    current_preamble = Enum.take(xmas_data, @preamble_length)
    case is_sum_possible(current_preamble, Enum.fetch!(xmas_data, index)) do
      true -> {_first, xmas_data} = List.pop_at(xmas_data, 0)
              find_first_error_num(xmas_data, index, error_num)
      _ -> find_first_error_num([], index, Enum.fetch!(xmas_data, index))
    end
  end

  def get_contigous_list(xmas_data, xmas_data_ref, invalid_number, contigous_sum \\ 0, contigous_list \\ [])
  def get_contigous_list([h | _t], _xmas_data_ref, invalid_number, contigous_sum, contigous_list) when
    h + contigous_sum === invalid_number, do: [h | contigous_list]
  def get_contigous_list([h | _t], xmas_data_ref, invalid_number, contigous_sum, _contigous_list) when
    h + contigous_sum > invalid_number do
    {_first, new_xmas_data} = List.pop_at(xmas_data_ref, 0)
    get_contigous_list(new_xmas_data, new_xmas_data, invalid_number, 0, [])
  end

  def get_contigous_list([h | t], xmas_data_ref, invalid_number, contigous_sum, contigous_list) do
    get_contigous_list(t, xmas_data_ref, invalid_number, h + contigous_sum, [h | contigous_list])
  end

end
