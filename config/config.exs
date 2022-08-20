# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :plug_http_cache_demo, PlugHTTPCacheDemoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PlugHTTPCacheDemoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PlugHTTPCacheDemo.PubSub,
  live_view: [signing_salt: "/THIbzR3"]

config :plug_http_cache_demo, :plug_http_cache_opts, store: :http_cache_store_native

config :http_cache_store_native, :memory_limit, 1024 * 1024 * 120
config :http_cache_store_native, :max_concurrency, 1

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
