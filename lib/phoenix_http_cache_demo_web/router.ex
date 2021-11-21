defmodule PhoenixHttpCacheDemoWeb.Router do
  use PhoenixHttpCacheDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PhoenixHttpCacheDemoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :cache do
    plug PlugHTTPCache, Application.get_env(:phoenix_http_cache_demo, :plug_http_cache_opts)
    plug PlugCacheControl, directives: [:public, s_maxage: 60 * 10]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixHttpCacheDemoWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/", PageController, :invalidate

    scope "/fibo" do
      pipe_through :cache
      get "/", FiboController, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixHttpCacheDemoWeb do
  #   pipe_through :api
  # end
end
