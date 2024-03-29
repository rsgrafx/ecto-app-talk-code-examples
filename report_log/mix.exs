defmodule ReportLog.MixProject do
  use Mix.Project

  def project do
    [
      app: :report_log,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ReportLog.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:postgrex, "~> 0.13.5"},
      {:poison, "~> 3.1"}
    ]
  end

  defp aliases do
    [
      "ecto.gen.migration": ["ecto.gen.migration -r ReportLog.Repo"]
    ]
  end
end
