defmodule PlugHTTPCacheDemoWeb.FiboController do
  use PlugHTTPCacheDemoWeb, :controller

  alias PlugHTTPCacheDemoWeb.Plug.RangeRequest

  @multiples [2, 3, 5, 7, 11, 20]

  def index(conn, %{"number" => number_str}) do
    {number, _} = Integer.parse(number_str)
    result = PlugHTTPCacheDemo.fib(number)

    conn
    |> set_alternate_keys(result)
    |> RangeRequest.attach_callback()
    |> render("index.html", number: number_str, result: result)
  end

  defp set_alternate_keys(conn, result) do
    multiples = for multiple <- @multiples, rem(result, multiple) == 0, do: multiple

    PlugHTTPCache.set_alternate_keys(conn, multiples)
  end
end
