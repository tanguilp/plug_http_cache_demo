defmodule PlugHTTPCacheDemoWeb.Plug.SetABTestCookie do
  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    case Plug.Conn.get_session(conn, "ab-test") do
      "a" ->
        conn

      "b" ->
        conn

      nil ->
        Plug.Conn.put_session(conn, "ab-test", rand_a_or_b())
    end
  end

  defp rand_a_or_b() do
    to_string([:rand.uniform(2) + 96])
  end
end
