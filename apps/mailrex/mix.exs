defmodule Mailrex.MixProject do
  use Mix.Project

  def project do
    [
      app: :mailrex,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mailrex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:html_sanitize_ex, "~> 1.3"},
      {:bamboo, "~> 1.1"},
      {:redix, "~> 0.7.1"}
    ]
  end
end
