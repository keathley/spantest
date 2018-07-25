defmodule Spantest.Router do
  use Plug.Router

  # require Spandex

  alias Spantest.Tracer

  plug :match
  plug Spandex.Plug.StartTrace
  plug Plug.Parsers, parsers: [Msgpax.PlugParser, :urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  plug :dispatch
  plug Spandex.Plug.EndTrace

  get "/hello" do
    Tracer.start_trace("hello", service: :spantest)

    conn = fetch_query_params(conn)
    word = conn.query_params["word"]

    result =
      word
      |> reverse
      |> capitalize

    conn = send_resp(conn, 200, result)
    Tracer.finish_trace()
    conn
  end

  match _ do
    # IO.inspect(conn.body_params)
    IO.puts "Got traces..."
    traces = conn.body_params
    File.write("traces.exs", :erlang.term_to_binary(traces))
    send_resp(conn, 200, "ok")
  end

  defp reverse(word) do
    Tracer.start_span("reverse", service: :reverser, type: :client)
    rev = String.reverse(word)
    Tracer.finish_span()
    rev
  end

  defp capitalize(word) do
    Tracer.start_span("capitalize", service: :capitalizer, type: :client)
    cap = String.capitalize(word)
    Tracer.finish_span()
    cap
  end
end
