defmodule PlugHTTPCacheDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

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
    [{TelemetryMetricsStatsd, metrics: PlugHTTPCacheDemo.Telemetry.metrics(), host: "statsd_exporter", formatter: :datadog}]
  end

  defp env_specific_children(_) do
    []
  end

end
