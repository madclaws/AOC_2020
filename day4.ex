defmodule Day4 do
  @moduledoc """
  --- Day 4: Passport Processing ---
  Part1 -> In your batch file, how many passports are valid?
  Part2 -> Excessive srutiny check, for each fields
  """

  def solve_part1 do
    raw_passport_data = generate_raw_passport_data()
    find_valid_passport_count(raw_passport_data, "part1")
  end

  def solve_part2 do
    raw_passport_data = generate_raw_passport_data()
    find_valid_passport_count(raw_passport_data, "part2")
  end

  defp generate_raw_passport_data do
    File.stream!("passport_data.txt")
    |> Enum.map(&String.trim/1)
  end

  defp find_valid_passport_count(raw_passport_data, part, accumulator \\ %{}, valid_count \\ 0)
  defp find_valid_passport_count([], _part, _accumulator, valid_count), do: valid_count

  defp find_valid_passport_count([h | t], part, accumulator, valid_count) when h === "" do
    if is_valid_passport?(accumulator, part) do
      find_valid_passport_count(t, part, %{}, valid_count + 1)
    else
      find_valid_passport_count(t, part, %{}, valid_count)
    end
  end

  defp find_valid_passport_count([h | t], part, accumulator, valid_count) do
    key_val_pairs = String.split(h, " ")
    accumulator = update_accumulator(accumulator, key_val_pairs)
    # IO.puts(inspect accumulator)
    find_valid_passport_count(t, part, accumulator, valid_count)
  end

  defp is_valid_passport?(passport_data, part) do
    valid_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    rem_keys = Enum.filter(Map.keys(passport_data), fn psprt ->
      psprt !== "cid"
    end)

    with true <- Enum.count(rem_keys) === Enum.count(valid_keys),
         true <- passes_scrutiny_check?(passport_data, rem_keys, part) do
          true
    end
  end

  defp update_accumulator(accumulator, key_val_pairs) do
    Enum.reduce(key_val_pairs, accumulator, fn psprt, accumulator ->
      [k, v] = String.split(psprt, ":")
      Map.put(accumulator, k, v)
    end)
  end

  defp passes_scrutiny_check?(_passport_data, _rem_keys, "part1"), do: true
  defp passes_scrutiny_check?(passport_data, rem_keys, _part) do
    rem_keys
    |> Enum.all?(fn key ->
      is_extra_valid?(key, passport_data[key])
    end)
  end

  def is_extra_valid?("byr", val) do
    is_number_valid?(Integer.parse(val), 1920, 2002)
  end

  def is_extra_valid?("iyr", val) do
    is_number_valid?(Integer.parse(val), 2010, 2020)
  end

  def is_extra_valid?("eyr", val) do
    is_number_valid?(Integer.parse(val), 2020, 2030)
  end

  def is_extra_valid?("hgt", val) do
    is_hgt_valid?(String.contains?(val, "cm") or String.contains?(val, "in"), val)
  end

  def is_extra_valid?("hcl", val) do
    is_hcl_valid?(String.at(val, 0) === "#", val)
  end

  def is_extra_valid?("ecl", val) do
    val in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  end

  def is_extra_valid?("pid", val) do
    String.length(val) === 9
  end
  def is_extra_valid?(_key, _val), do: false


  defp is_number_valid?({val, _}, low_limit, high_limit) when val >= 1000 and val <= 9999 do
    val >= low_limit and val <= high_limit
  end

  defp is_number_valid?(_, _, _), do: false

  defp is_hgt_valid?(has_suffix, val)
  defp is_hgt_valid?(true, val) do
    len = String.length(val)
    suffix = String.slice(val, len - 2, 2)
    [num, ""] = String.split(val, suffix)
    {parsed_num, _} = Integer.parse(num)

    case suffix do
      "cm" when parsed_num >= 150 and parsed_num <= 193 -> true
      "in" when parsed_num >= 59 and parsed_num <= 76 -> true
      _ -> false
    end
  end
  defp is_hgt_valid?(_has_suffix, _val), do: false

  defp is_hcl_valid?(true, color) do
    String.slice(color, 1, 6)
    |> String.to_charlist
    |> Enum.filter(fn char_code ->
      (char_code >= 97 and char_code <= 102) or (char_code >= 48 and char_code <= 57)
    end)
    |> Enum.count === 6
  end

  defp is_hcl_valid?(_, _), do: false
end
