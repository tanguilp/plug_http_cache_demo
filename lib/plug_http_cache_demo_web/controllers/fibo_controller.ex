defmodule PlugHTTPCacheDemoWeb.FiboController do
  use PlugHTTPCacheDemoWeb, :controller

  alias PlugHTTPCacheDemo.RomanNumeral
  alias PlugHTTPCacheDemoWeb.Plug.RangeRequest

  @multiples [2, 3, 5, 7, 11, 20]

  def index(conn, %{"number" => number_str}) do
    {number, _} = Integer.parse(number_str)
    result = PlugHTTPCacheDemo.fib(number)

    ab_test = Plug.Conn.get_session(conn, "ab-test")

    conn
    |> set_alternate_keys(result)
    |> RangeRequest.attach_callback()
    |> Plug.Conn.prepend_resp_headers([{"vary", "ab-test"}])
    |> render("index.html",
      number: format_abtest(number, ab_test),
      result: format_abtest(result, ab_test)
    )
  end

  defp set_alternate_keys(conn, result) do
    multiples = for multiple <- @multiples, rem(result, multiple) == 0, do: multiple

    PlugHTTPCache.set_alternate_keys(conn, multiples)
  end

  defp format_abtest(number, "a"), do: number
  defp format_abtest(number, "b"), do: RomanNumeral.convert(number)
end
