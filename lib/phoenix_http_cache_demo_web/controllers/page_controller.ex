defmodule PhoenixHttpCacheDemoWeb.PageController do
  use PhoenixHttpCacheDemoWeb, :controller

  def index(conn, %{"number" => number_str}) do
    {number, _} = Integer.parse(number_str)
    render(conn, "index.html", number: number_str, result: PhoenixHttpCacheDemo.fib(number))
  end

  def index(conn, _params) do
    render(conn, "index.html", number: nil)
  end
end
