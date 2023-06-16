defmodule PlugHTTPCacheDemo.Telemetry do
  import Telemetry.Metrics

  def metrics() do
    [
      summary("http_cache.lookup.total_time", unit: :microsecond, tag_values: &add_node/1, tags: [:node]),
      summary("http_cache.cache.total_time", unit: :microsecond, tag_values: &add_node/1, tags: [:node]),
      counter("http_cache.cache.total_time", event_name: [:http_cache, :cache_operation], tag_values: &add_node/1, tags: [:node]),
      counter("http_cache.compress_operation.count", event_name: [:http_cache, :compress_operation], tag_values: &add_node/1, tags: [:node]),
      counter("http_cache.store.error.count", event_name: [:http_cache, :store, :error], tag_values: &add_node/1, tags: [:node, :reason]),
      counter("http_cache.decompress_operation.count", event_name: [:http_cache, :decompress_operation], tag_values: &add_node/1, tags: [:node]),
      counter("http_cache_store_memory.object_deleted.count", event_name: [:http_cache_store_memory, :object_deleted], tag_values: &add_node/1, tags: [:node, :reason]),
      last_value("http_cache_store_memory.memory.total_mem", unit: :byte, tag_values: &add_node/1, tags: [:node]),
      last_value("http_cache_store_memory.memory.objects_mem", unit: :byte, tag_values: &add_node/1, tags: [:node]),
      last_value("http_cache_store_memory.memory.lru_mem", unit: :byte, tag_values: &add_node/1, tags: [:node]),
      last_value("http_cache_store_memory.memory.objects_count", tag_values: &add_node/1, tags: [:node]),
      summary("http_cache_store_memory.lru_nuker.stop.duration", unit: {:native, :microsecond}, tag_values: &add_node/1, tags: [:node]),
      summary("http_cache_store_memory.expired_lru_entry_sweeper.stop.duration", unit: {:native, :microsecond}, tag_values: &add_node/1, tags: [:node]),
      summary("http_cache_store_memory.expired_resp_sweeper.stop.duration", unit: {:native, :microsecond}, tag_values: &add_node/1, tags: [:node]),
      counter("plug_http_cache.hit.count", event: [:plug_http_cache, :hit], tag_values: &add_node/1, tags: [:node]),
      counter("plug_http_cache.miss.count", event: [:plug_http_cache, :miss], tag_values: &add_node/1, tags: [:node])
    ]
  end

  defp add_node(tags), do: Map.put(tags, :node, node())
end
