defmodule PlugHTTPCacheDemo.RomanNumeral do
  @numerals [
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]

  def convert(number) do
    convert(number, @numerals)
  end

  defp convert(0, _numerals), do: ""

  defp convert(number, [{arabic, roman} | tail]) when number >= arabic do
    roman <> convert(number - arabic, [{arabic, roman} | tail])
  end

  defp convert(number, [{arabic, _roman} | tail]) when number < arabic do
    convert(number, tail)
  end
end
