defmodule PlugHTTPCacheDemoWeb.Plug.RangeRequest do
  def attach_callback(conn) do
    Plug.Conn.register_before_send(conn, &handle_range_request/1)
  end

  defp handle_range_request(conn) do
    body_bin = IO.iodata_to_binary(conn.resp_body)
    body_len = byte_size(body_bin)

    case requested_range(conn) do
      {:bytes, [{start_offset, :infinity}]} ->
        conn
        |> set_body(body_bin, start_offset, body_len - 1)
        |> set_headers(start_offset, body_len - 1, body_len)

      {:bytes, [{start_offset, end_offset}]} ->
        conn
        |> set_body(body_bin, start_offset, end_offset)
        |> set_headers(start_offset, end_offset, body_len)

      {:bytes, [last_n_bytes]} when is_integer(last_n_bytes) ->
        conn
        |> set_body(body_bin, body_len + last_n_bytes, body_len - 1)
        |> set_headers(body_len + last_n_bytes, body_len - 1, body_len)

      nil ->
        conn
    end
  end

  defp requested_range(conn) do
    case Plug.Conn.get_req_header(conn, "range") do
      [range] ->
        :cow_http_hd.parse_range(range)

      [] ->
        nil
    end
  end

  defp set_body(conn, body_bin, start_offset, end_offset) do
    %Plug.Conn{conn | resp_body: :binary.part(body_bin, start_offset, end_offset - start_offset + 1)}
  end

  defp set_headers(conn, start_offset, end_offset, body_len) do
    conn
    |> Plug.Conn.put_resp_header("content-range", "bytes #{start_offset}-#{end_offset}/#{body_len}")
    |> Plug.Conn.put_resp_header("content-length", to_string(end_offset - start_offset + 1))
  end
end
