defmodule Spantest.MixProject do
  use Mix.Project

  def project do
    [
      app: :spantest,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Spantest.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.0"},
      {:plug, "~> 1.6"},
      {:ecto, "~> 2.2"},
      {:spandex, "~> 1.6"},
      {:httpoison, "~> 1.2"},
      {:jason, "~> 1.1"},
      {:msgpax, "~> 1.1"},
    ]
  end
end
