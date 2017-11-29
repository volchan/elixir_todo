defmodule ElixirTodo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_todo,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      application: applications(Mix.env),
      extra_applications: [:logger]
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:remix, "~> 0.0.1", only: :dev},
      {:csv, "~> 2.0.0"}
    ]
  end
end
