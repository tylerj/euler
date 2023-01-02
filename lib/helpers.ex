defmodule Helpers do
  import Integer, only: [is_even: 1]

  use Memoize
  def prime?(2), do: true
  def prime?(n) when n < 2 or rem(n, 2) == 0, do: false
  def prime?(n), do: prime?(n, 3)

  defp prime?(n, x) when n < x * x, do: true
  defp prime?(n, x) when rem(n, x) == 0, do: false
  defp prime?(n, x), do: prime?(n, x + 2)

  def prime_factors(num), do: divisors(num) |> Enum.filter(&prime?/1)
  def factors(num), do: divisors(num)
  def proper_divisors(num), do: divisors(num) |> List.delete_at(-1)

  def divisors(0), do: []

  def divisors(num) do
    for x <- trunc(:math.sqrt(num))..1//-1, rem(num, x) == 0, reduce: [] do
      acc -> [x | [div(num, x) | acc]]
    end
    |> Stream.uniq()
    |> Enum.sort()
  end

  def divisor_count(0), do: 0

  def divisor_count(num) do
    for x <- 1..trunc(:math.sqrt(num)), rem(num, x) == 0, reduce: 0 do
      acc -> acc + 2
    end
  end

  def palindrome?(num), do: Integer.digits(num) |> Enum.reverse() == Integer.digits(num)

  def triangular(num) do
    for x <- 1..num, reduce: 0 do
      acc -> acc + x
    end
  end

  def factorial(num) do
    for x <- 1..num, reduce: 1 do
      acc -> acc * x
    end
  end

  def n_choose_k(n, k) do
    factorial(n) / (factorial(n - k) * factorial(k))
  end

  def collatz_sequence(x) when is_integer(x), do: collatz_sequence([x])
  def collatz_sequence([1 | _] = digits), do: Enum.reverse(digits)

  def collatz_sequence([x | _] = digits) do
    collatz_sequence([next_collatz(x) | digits])
  end

  def next_collatz(x) when is_even(x), do: div(x, 2)
  def next_collatz(x), do: 3 * x + 1

  def collatz_sequence_size(1), do: 1

  defmemo(collatz_sequence_size(x),
    do: 1 + collatz_sequence_size(next_collatz(x))
  )

  def permutations([]), do: [[]]

  def permutations(list) do
    for elem <- list, rest <- permutations(List.delete(list, elem)), do: [elem | rest]
  end

  def fibonacci_number(index) do
    for x <- 1..index, reduce: 1 do
      acc -> acc + x
    end
  end

  def fibonacci_list(1), do: [1]
  def fibonacci_list(2), do: [1, 1]

  def fibonacci_list(count) do
    1..max(count - 2, 1)
    |> Enum.reduce([1, 1], fn _, [a | [b | _]] = acc ->
      [a + b | acc]
    end)
    |> Enum.reverse()
  end
end
