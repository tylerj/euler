defmodule Euler do
  import Helpers

  @moduledoc """
  Documentation for `Euler`.
  """

  def problem_1 do
    1..999
    |> Stream.filter(&(rem(&1, 3) == 0 or rem(&1, 5) == 0))
    |> Enum.sum()
  end

  def problem_2(a \\ 1, b \\ 2, sum \\ 0)
  def problem_2(_, b, sum) when b > 4_000_000, do: sum
  def problem_2(a, b, sum) when rem(b, 2) == 0, do: problem_2(b, a + b, sum + b)
  def problem_2(a, b, sum), do: problem_2(b, a + b, sum)

  def problem_3(input \\ 600_851_475_143, current \\ 2, largest \\ -1)
  def problem_3(input, current, largest) when current == input, do: max(input, largest)

  def problem_3(input, current, largest) do
    if rem(input, current) == 0 do
      div(input, current) |> problem_3(2, max(current, largest))
    else
      problem_3(input, current + 1, largest)
    end
  end

  def problem_4 do
    for a <- 100..999, b <- 100..999, palindrome?(a * b), reduce: 0 do
      acc -> if acc > a * b, do: acc, else: a * b
    end
  end

  def problem_5(num \\ 20) do
    1..20
    |> Enum.all?(fn x -> rem(num, x) == 0 end)
    |> then(fn
      true -> num
      _ -> problem_5(num + 1)
    end)
  end

  def problem_6 do
    square_sums = Enum.sum(1..100) ** 2
    sum_squares = Enum.map(1..100, &(&1 ** 2)) |> Enum.sum()

    abs(square_sums - sum_squares)
  end

  def problem_7(num \\ 3, count \\ 1)
  def problem_7(num, 10_001), do: num - 2

  def problem_7(num, count) do
    if prime?(num), do: problem_7(num + 2, count + 1), else: problem_7(num + 2, count)
  end

  def problem_8(input, digits) do
    input
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.split(&1, "", trim: true))
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(digits, 1, :discard)
    |> Stream.map(&Enum.product/1)
    |> Enum.max()
  end

  def problem_9 do
    for a <- 1..400,
        c <- 1..500,
        pythag_triplet?(a, 1000 - c - a, c),
        do: a * (1000 - c - a) * c
  end

  def pythag_triplet?(a, b, c) do
    a ** 2 + b ** 2 == c ** 2
  end

  def problem_10(current \\ 3, sum \\ 2)
  def problem_10(current, sum) when current > 2_000_000, do: sum

  def problem_10(current, sum) do
    if prime?(current),
      do: problem_10(current + 2, sum + current),
      else: problem_10(current + 2, sum)
  end

  def problem_11(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {row, y}, acc ->
        row
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.with_index(1)
        |> Enum.reduce(acc, fn {col, x}, acc ->
          Map.put(acc, {x, y}, col)
        end)
      end)

    for x <- 1..20, y <- 1..17 do
      [
        [{x, y}, {x, y + 1}, {x, y + 2}, {x, y + 3}],
        [{x, y}, {x + 1, y}, {x + 2, y}, {x + 3, y}],
        [{x, y}, {x + 1, y + 1}, {x + 2, y + 2}, {x + 3, y + 3}],
        [{x, y}, {x - 1, y + 1}, {x - 2, y + 2}, {x - 3, y + 3}]
      ]
      |> Enum.map(fn coord_list ->
        coord_list
        |> Enum.map(&Map.get(grid, &1))
        |> Enum.reject(&is_nil/1)
        |> Enum.product()
      end)
      |> Enum.max()
    end
    |> Enum.max()
  end

  def problem_12(min_divisor_count \\ 500, x \\ 1, triangle \\ 0)

  def problem_12(min_divisor_count, x, triangle) do
    if divisor_count(triangle) > min_divisor_count,
      do: triangle,
      else: problem_12(min_divisor_count, x + 1, triangle + x)
  end

  def problem_13(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
    |> Integer.digits()
    |> Enum.take(10)
    |> Integer.undigits()
  end

  def problem_14(max \\ 999_999) do
    max..1//-1
    |> Enum.reduce({1, 0}, fn x, {_, largest} = acc ->
      case collatz_sequence_size(x) do
        size when size > largest -> {x, size}
        _ -> acc
      end
    end)
    |> elem(0)
  end

  def problem_15(max \\ 20) do
    n_choose_k(max * 2, max) |> trunc()
  end

  def problem_16 do
    (2 ** 1000)
    |> Integer.digits()
    |> Enum.sum()
  end

  def problem_17 do
    1..1000
    |> Stream.map(&NumberToWords.to_words/1)
    |> Stream.map(fn n ->
      String.replace(n, [" ", "-"], "")
      |> String.length()
    end)
    |> Enum.sum()
  end

  def problem_18(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reverse()
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> process_18()
    |> List.first()
  end

  def process_18([final_list]), do: final_list

  def process_18([a | [b | rest]]) do
    {new_b, _} =
      Enum.map_reduce(b, a, fn x, [y | [z | _] = tail] ->
        {x + max(y, z), tail}
      end)

    process_18([new_b | rest])
  end

  def problem_19 do
    for y <- 1901..2000,
        m <- 1..12,
        Date.new!(y, m, 1) |> Date.day_of_week() == 7,
        reduce: 0 do
      acc -> acc + 1
    end
  end

  def problem_19_alt do
    Date.range(~D[1901-01-01], ~D[2000-12-31])
    |> Enum.count(fn
      %Date{day: 1} = d -> Date.day_of_week(d) == 7
      _ -> false
    end)
  end

  def problem_20(x \\ 100) do
    factorial(x)
    |> Integer.digits()
    |> Enum.sum()
  end

  def problem_21 do
    map =
      1..9999
      |> Stream.map(fn x ->
        {
          x,
          proper_divisors(x) |> Enum.sum()
        }
      end)
      |> Enum.into(%{})

    for {k, v} <- map, k != v and map[v] == k, reduce: 0 do
      acc -> acc + k
    end
  end

  def problem_22 do
    with {:ok, input} <- File.read("inputs/p022_names.txt") do
      input
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(&Enum.slice(&1, 1..-2))
      |> Enum.sort()
      |> Stream.with_index(1)
      |> Stream.map(fn {name, index} ->
        (Enum.map(name, &(&1 - 64)) |> Enum.sum()) * index
      end)
      |> Enum.sum()
    end
  end

  def problem_23 do
    abundant_numbers =
      1..28123
      |> Enum.reduce([], fn x, abundant ->
        if proper_divisors(x) |> Enum.sum() > x do
          [x | abundant]
        else
          abundant
        end
      end)
      |> Enum.reverse()

    abundant_sums =
      abundant_numbers
      |> Stream.flat_map(fn a ->
        Enum.map(abundant_numbers, fn b ->
          a + b
        end)
      end)
      |> Stream.filter(fn x -> x <= 28123 end)
      |> Enum.uniq()

    (Enum.to_list(1..28123) -- abundant_sums) |> Enum.sum()
  end

  def problem_24(rank \\ 999_999, digits \\ [], available \\ [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

  def problem_24(0, digits, available) do
    IO.inspect(digits, label: "DIGITS")
    IO.inspect(available, label: "AVAILABLE")

    (Enum.reverse(digits) ++ available)
    |> Integer.undigits()
  end

  def problem_24(rank, digits, available) do
    options_per_digit = factorial(length(available) - 1)
    index = div(rank, options_per_digit)
    rem = rem(rank, options_per_digit)

    {digit, rest} = List.pop_at(available, index)

    problem_24(rem, [digit | digits], rest)
  end

  def problem_24_alt(rank \\ 1_000_000, digits \\ [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) do
    digits
    |> permutations()
    |> Enum.at(rank - 1)
    |> Integer.undigits()
  end

  def problem_25(num_digits \\ 1000, index \\ 2, a \\ 1, b \\ 1) do
    if Integer.digits(b) |> length() >= num_digits do
      index
    else
      problem_25(num_digits, index + 1, b, a + b)
    end
  end

  def problem_26 do
    1..1000
    |> Enum.each(fn x ->
      IO.puts(1 / x)
      # case Regex.run(~r/0\.\d*(\d+)\1+\d*/U, to_string(1 / x)) do
      # nil -> acc
      # [_, repeat] -> [{x, String.length(repeat), repeat} | acc]
      # end
    end)

    # |> Enum.max_by(fn {_, size, _} -> size end)
  end

  def problem_67(input), do: problem_18(input)
end
