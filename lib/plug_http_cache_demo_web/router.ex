defmodule PlugHTTPCacheDemoWeb.Router do
  use PlugHTTPCacheDemoWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PlugHTTPCacheDemoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlugHTTPCache, Application.get_env(:plug_http_cache_demo, :plug_http_cache_opts)
  end

  pipeline :cache_responses do
    plug PlugCacheControl, directives: [:public, s_maxage: 60 * 20]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlugHTTPCacheDemoWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/", PageController, :invalidate

    scope "/fibo" do
      pipe_through :cache_responses
      get "/", FiboController, :index
    end

    live_dashboard "/dashboard", metrics: PlugHTTPCacheDemo.Telemetry
  end
end
