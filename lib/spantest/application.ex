defmodule Spantest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Adapters.Cowboy2, scheme: :http, plug: Spantest.Router, options: [port: port()]},
      {Spandex.Datadog.ApiServer, spandex_opts()},
    ]

    opts = [strategy: :one_for_one, name: Spantest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port, do: System.get_env("PORT") |> String.to_integer

  defp spandex_opts, do: [
    host: System.get_env("DATADOG_HOST") || "localhost",
    port: System.get_env("DATADOG_PORT") || 8126,
    batch_size: (System.get_env("SPANDEX_BATCH_SIZE") || "10") |> String.to_integer(),
    sync_threshold: (System.get_env("SPANDEX_SYNC_THRESHOLD") || "100") |> String.to_integer(),
    http: HTTPoison
  ]
end
