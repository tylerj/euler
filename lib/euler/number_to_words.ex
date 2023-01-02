defmodule NumberToWords do
  def to_words(1000), do: "one thousand"

  def to_words(n) do
    Integer.digits(n)
    |> Enum.reverse()
    |> then(fn
      [ones | [tens | rest]] ->
        [tens_words(tens, ones) | rest_words(rest)]

      [ones] ->
        [digit_word(ones)]
    end)
    |> Enum.reverse()
    |> List.flatten()
    |> Enum.join(" ")
    |> String.replace_trailing(" and ", "")
    |> String.trim()
  end

  defp rest_words([]), do: []

  defp rest_words(digits) do
    [
      "and"
      | digits
        |> Enum.with_index()
        |> Enum.map(fn
          {digit, 0} -> digit_with_suffix(digit, "hundred")
        end)
    ]
  end

  defp digit_with_suffix(digit, suffix), do: digit_word(digit) <> " " <> suffix

  @digit_words %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine"
  }
  defp digit_word(digit), do: @digit_words[digit]
  defp tens_words(0, digit), do: digit_word(digit)
  defp tens_words(1, 0), do: "ten"
  defp tens_words(1, 1), do: "eleven"
  defp tens_words(1, 2), do: "twelve"
  defp tens_words(1, 3), do: "thirteen"
  defp tens_words(1, 4), do: "fourteen"
  defp tens_words(1, 5), do: "fifteen"
  defp tens_words(1, 6), do: "sixteen"
  defp tens_words(1, 7), do: "seventeen"
  defp tens_words(1, 8), do: "eighteen"
  defp tens_words(1, 9), do: "nineteen"
  defp tens_words(2, 0), do: "twenty"
  defp tens_words(3, 0), do: "thirty"
  defp tens_words(4, 0), do: "forty"
  defp tens_words(5, 0), do: "fifty"
  defp tens_words(6, 0), do: "sixty"
  defp tens_words(7, 0), do: "seventy"
  defp tens_words(8, 0), do: "eighty"
  defp tens_words(9, 0), do: "ninety"
  defp tens_words(tens, ones), do: tens_words(tens, 0) <> "-" <> digit_word(ones)
end
