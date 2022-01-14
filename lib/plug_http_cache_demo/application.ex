defmodule PlugHTTPCacheDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Telemetry.Metrics

  @topologies [
    docker_compose: [
      strategy: Cluster.Strategy.Gossip
    ]
  ]

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PlugHTTPCacheDemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PlugHTTPCacheDemo.PubSub},
      # Start the Endpoint (http/https)
      PlugHTTPCacheDemoWeb.Endpoint,
      # Start a worker by calling: PlugHTTPCacheDemo.Worker.start_link(arg)
      # {PlugHTTPCacheDemo.Worker, arg},
      {TelemetryMetricsStatsd, metrics: metrics(), host: "statsd_exporter", formatter: :datadog},
      {Cluster.Supervisor, [@topologies, [name: PlugHTTPCacheDemo.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlugHTTPCacheDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PlugHTTPCacheDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp metrics() do
    [
      summary("http_cache.lookup.total_time", unit: :microsecond, tag_values: &add_node/1, tags: [:node]),
      summary("http_cache.cache.total_time", unit: :microsecond, tag_values: &add_node/1, tags: [:node]),
      sum("http_cache.invalidation.count", tag_values: &add_node/1, tags: [:node, :type]),
      counter("http_cache.compress_operation.count", event_name: [:http_cache, :compress_operation], tag_values: &add_node/1, tags: [:node]),
      counter("http_cache.decompress_operation.count", event_name: [:http_cache, :decompress_operation], tag_values: &add_node/1, tags: [:node]),
      counter("http_cache_store_native.object_deleted.count", event_name: [:http_cache_store_native, :object_deleted], tag_values: &add_node/1, tags: [:node, :reason]),
      last_value("http_cache_store_native.memory.total_mem", unit: :byte, tag_values: &add_node/1, tags: [:node]),
      last_value("http_cache_store_native.memory.objects_mem", unit: :byte, tag_values: &add_node/1, tags: [:node]),
      last_value("http_cache_store_native.memory.lru_mem", unit: :byte, tag_values: &add_node/1, tags: [:node]),
      last_value("http_cache_store_native.memory.objects_count", tag_values: &add_node/1, tags: [:node]),
      summary("http_cache_store_native.lru_nuker.stop.duration", unit: {:native, :microsecond}, tag_values: &add_node/1, tags: [:node]),
      summary("http_cache_store_native.expired_lru_entry_sweeper.stop.duration", unit: {:native, :microsecond}, tag_values: &add_node/1, tags: [:node]),
      summary("http_cache_store_native.expired_resp_sweeper.stop.duration", unit: {:native, :microsecond}, tag_values: &add_node/1, tags: [:node]),
      counter("plug_http_cache.hit.count", event: [:plug_http_cache, :hit], tag_values: &add_node/1, tags: [:node]),
      counter("plug_http_cache.miss.count", event: [:plug_http_cache, :miss], tag_values: &add_node/1, tags: [:node]),
      counter("plug_http_cache.overloaded.count", event: [:plug_http_cache, :overloaded], tag_values: &add_node/1, tags: [:node]),
    ]
  end

  defp add_node(tags), do: Map.put(tags, :node, node())
end
