traces = File.read!("traces.exs") |> :erlang.binary_to_term |> Map.get("_msgpack")


defmodule Graph do
  def children(trace, %{"span_id" => id}) do
    trace
    |> Enum.filter(fn span -> span["parent_id"] == id end)
  end

  def build_graph(inner_graph) do
    """
    digraph {
      rankdir="LR"
      #{inner_graph}
    }
    """
  end

  def label(span, kid) do
    ~s|[label="#{kid["name"]} - #{kid["duration"]}"]|
  end
end


Enum.map(traces, fn trace ->
  Enum.map(trace, fn span ->
    Graph.children(trace, span)
    |> Enum.map(fn kid -> span["service"] <> " -> " <> kid["service"] <> " #{Graph.label(span, kid)};" end)
    |> Enum.join("\n")
  end)
end)
|> Enum.at(0)
|> Enum.join("")
|> Graph.build_graph
|> IO.puts
