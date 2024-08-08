defmodule PlugHTTPCacheDemoWeb.Plug.SetABTestHeader do
  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    ab_test = Plug.Conn.get_session(conn, "ab-test") || raise "Missing ab test cookie value"

    Plug.Conn.put_req_header(conn, "ab-test", ab_test)
  end
end
