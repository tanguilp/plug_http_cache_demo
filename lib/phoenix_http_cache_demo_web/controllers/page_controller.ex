defmodule PhoenixHttpCacheDemoWeb.PageController do
  use PhoenixHttpCacheDemoWeb, :controller

  def index(conn, params) do
    render(conn, "index.html", number: params["number"])
  end
end
