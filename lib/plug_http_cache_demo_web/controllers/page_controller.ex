defmodule PlugHTTPCacheDemoWeb.PageController do
  use PlugHTTPCacheDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def invalidate(conn, %{"url" => url}) do
    http_cache_opts = Application.get_env(:plug_http_cache_demo, :plug_http_cache_opts)[:http_cache]

    case :http_cache.invalidate_url(url, http_cache_opts) do
      {:ok, :undefined} ->
        put_flash(conn, :info, "Invalidation successfull")

      {:ok, nb_deleted} ->
        put_flash(conn, :info, "Invalidation successfull (#{nb_deleted} objects deleted)")

      {:error, reason} ->
        put_flash(conn, :error, "Invalidation failed (reason: #{inspect(reason)})")
    end
    |> redirect(to: "/")
  end

  def invalidate(conn, %{"multiple" => multiple_str}) do
    http_cache_opts = Application.get_env(:plug_http_cache_demo, :plug_http_cache_opts)[:http_cache]

    {multiple, _} = Integer.parse(multiple_str)

    case :http_cache.invalidate_by_alternate_key(multiple, http_cache_opts) do
      {:ok, :undefined} ->
        put_flash(conn, :info, "Invalidation successfull")

      {:ok, nb_deleted} ->
        put_flash(conn, :info, "Invalidation successfull (#{nb_deleted} objects deleted)")

      {:error, reason} ->
        put_flash(conn, :error, "Invalidation failed (reason: #{inspect(reason)})")
    end
    |> redirect(to: "/")
  end
end
