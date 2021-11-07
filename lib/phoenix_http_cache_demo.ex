defmodule PhoenixHttpCacheDemo do
  @moduledoc """
  PhoenixHttpCacheDemo keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def fib(0), do: 0
  def fib(1), do: 1
  def fib(n), do: fib(0, 1, n-2)

  def fib(_, prv, -1), do: prv
  def fib(prvprv, prv, n) do
    next = prv + prvprv
    fib(prv, next, n-1)
  end
end
