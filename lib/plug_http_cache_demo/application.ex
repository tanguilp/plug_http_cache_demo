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

  @env Mix.env()

  @impl true
  def start(_type, _args) do
    children =
      [
        PlugHTTPCacheDemoWeb.Telemetry,
        {Phoenix.PubSub, name: PlugHTTPCacheDemo.PubSub},
        PlugHTTPCacheDemoWeb.Endpoint,
        {Cluster.Supervisor, [@topologies, [name: PlugHTTPCacheDemo.ClusterSupervisor]]}
      ] ++ env_specific_children(@env)

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

  defp env_specific_children(:prod) do
    [{TelemetryMetricsStatsd, metrics: metrics(), host: "statsd_exporter", formatter: :datadog}]
  end

  defp env_specific_children(_) do
    []
  end

  defp metrics() do
    [
      summary("http_cache.lookup.total_time",
        unit: :microsecond,
        tag_values: &add_node/1,
        tags: [:node]
      ),
      summary("http_cache.cache.total_time",
        unit: :microsecond,
        tag_values: &add_node/1,
        tags: [:node]
      ),
      sum("http_cache.invalidation.count", tag_values: &add_node/1, tags: [:node, :type]),
      counter("http_cache.compress_operation.count",
        event_name: [:http_cache, :compress_operation],
        tag_values: &add_node/1,
        tags: [:node]
      ),
      counter("http_cache.decompress_operation.count",
        event_name: [:http_cache, :decompress_operation],
        tag_values: &add_node/1,
        tags: [:node]
      ),
      counter("http_cache_store_native.object_deleted.count",
        event_name: [:http_cache_store_native, :object_deleted],
        tag_values: &add_node/1,
        tags: [:node, :reason]
      ),
      last_value("http_cache_store_native.memory.total_mem",
        unit: :byte,
        tag_values: &add_node/1,
        tags: [:node]
      ),
      last_value("http_cache_store_native.memory.objects_mem",
        unit: :byte,
        tag_values: &add_node/1,
        tags: [:node]
      ),
      last_value("http_cache_store_native.memory.lru_mem",
        unit: :byte,
        tag_values: &add_node/1,
        tags: [:node]
      ),
      last_value("http_cache_store_native.memory.objects_count",
        tag_values: &add_node/1,
        tags: [:node]
      ),
      summary("http_cache_store_native.lru_nuker.stop.duration",
        unit: {:native, :microsecond},
        tag_values: &add_node/1,
        tags: [:node]
      ),
      summary("http_cache_store_native.expired_lru_entry_sweeper.stop.duration",
        unit: {:native, :microsecond},
        tag_values: &add_node/1,
        tags: [:node]
      ),
      summary("http_cache_store_native.expired_resp_sweeper.stop.duration",
        unit: {:native, :microsecond},
        tag_values: &add_node/1,
        tags: [:node]
      ),
      counter("plug_http_cache.hit.count",
        event: [:plug_http_cache, :hit],
        tag_values: &add_node/1,
        tags: [:node]
      ),
      counter("plug_http_cache.miss.count",
        event: [:plug_http_cache, :miss],
        tag_values: &add_node/1,
        tags: [:node]
      ),
      counter("plug_http_cache.overloaded.count",
        event: [:plug_http_cache, :overloaded],
        tag_values: &add_node/1,
        tags: [:node]
      )
    ]
  end

  defp add_node(tags), do: Map.put(tags, :node, node())
end
