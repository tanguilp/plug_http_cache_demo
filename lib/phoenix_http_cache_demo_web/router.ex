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

  pipeline :public do
    plug PlugCacheControl, directives: [:public, s_maxage: 120]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixHttpCacheDemoWeb do
    pipe_through :browser
    pipe_through :public

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixHttpCacheDemoWeb do
  #   pipe_through :api
  # end
end
