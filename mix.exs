defmodule CrackleAxe.MixProject do
  use Mix.Project

  def project do
    [
      app: :crackle_axe,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {CrackleAxe.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:typed_struct, "~> 0.3.0"},
      {:uuid, "~> 1.1"}
    ]
  end
end
