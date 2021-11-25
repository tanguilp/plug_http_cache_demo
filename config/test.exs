import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plug_http_cache_demo, PlugHTTPCacheDemoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "WShLU/5zteDlFwKay+G5Z8l97WkscqbAfnz1odF7foDNm0h/M/WGtHxZToByVtzf",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
