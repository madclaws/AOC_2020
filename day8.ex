defmodule Day8 do
  @moduledoc """
  --- Day 8: Handheld Halting ---
  Part 1 -> Immediately before any instruction is executed a second time,
  what value is in the accumulator
  Part2 -> What is the value of the accumulator after the program terminates?.
  """

  def solve_part1 do
    code_list = get_the_code()
    {acc, _jmp_pos, _terminated} = run_program(code_list, Enum.count(code_list) - 1)
    acc
  end

  def solve_part2 do
    # we have all the jmp position we executed.
    # We can go through each and change that to nop, and execute the code again
    # if we get true for a particular jmp pos, then

    code_list = get_the_code()
    {_acc, jmp_pos, _terminated} = run_program(code_list, Enum.count(code_list) - 1)
    debug_jmp_code(jmp_pos, code_list)
  end

  def get_the_code do
    File.stream!("code.txt")
    |> Enum.map(&String.trim/1)
  end

  def run_program(code_list, total_lines, current_line \\ 0, execute_line_list \\ [], acc \\ 0, jmp_pos \\ [])
  def run_program(_code_list, total_lines, current_line, _execute_line_list, acc, jmp_pos)
    when current_line > total_lines, do: {acc, jmp_pos, true}
  def run_program(code_list, total_lines, current_line, execute_line_list, acc, jmp_pos) do
    [opr, oprnd] = String.split(Enum.fetch!(code_list, current_line))
    case current_line in execute_line_list do
      true -> {acc, jmp_pos, false}
      _ -> case opr do
        "nop" -> run_program(code_list, total_lines, current_line + 1, [current_line | execute_line_list], acc,
          jmp_pos)
        "acc" -> operand =  String.to_integer(oprnd)
          run_program(code_list, total_lines, current_line + 1, [current_line | execute_line_list],
          acc + operand, jmp_pos)
        "jmp" -> run_program(code_list, total_lines, current_line + String.to_integer(oprnd), [current_line | execute_line_list],
          acc, [current_line | jmp_pos])
      end
    end
  end

  def debug_jmp_code(jmp_pos, code_list, acc \\ 0)
  def debug_jmp_code([], _code_list, acc), do: acc
  def debug_jmp_code([h | t], code_list, _acc) do
    new_code_list = List.update_at(code_list, h, fn expr -> String.replace(expr, "jmp", "nop") end)
    {new_acc, _jmp_pos, terminated} = run_program(new_code_list, Enum.count(new_code_list) - 1)
    case terminated do
      true -> debug_jmp_code([], code_list, new_acc)
      _ ->
        debug_jmp_code(t, code_list, 0)
    end
  end

end
