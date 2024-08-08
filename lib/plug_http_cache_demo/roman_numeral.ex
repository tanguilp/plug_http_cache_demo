defmodule PlugHTTPCacheDemo.RomanNumeral do
    def convert(n) when n >= 1000, do: remove_and_continue(n, "M", 1000)
  def convert(n) when n >= 900,  do: remove_and_continue(n, "CM", 900)
  def convert(n) when n >= 500,  do: remove_and_continue(n, "D", 500)
  def convert(n) when n >= 400,  do: remove_and_continue(n, "CD", 400)
  def convert(n) when n >= 100,  do: remove_and_continue(n, "C", 100)
  def convert(n) when n >= 90,   do: remove_and_continue(n, "XC", 90)
  def convert(n) when n >= 50,   do: remove_and_continue(n, "L", 50)
  def convert(n) when n >= 40,   do: remove_and_continue(n, "XL", 40)
  def convert(n) when n >= 10,   do: remove_and_continue(n, "X", 10)
  def convert(9),                do: "IX"
  def convert(n) when n >= 5,    do: remove_and_continue(n, "V", 5)
  def convert(4),                do: "IV"
  def convert(n),                do: String.duplicate("I", n)

  defp remove_and_continue(total, roman, number) do
    String.duplicate(roman, div(total, number)) <> convert(rem(total, number))
  end
end
