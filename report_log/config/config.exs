# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :report_log, ecto_repos: [PGChannel.Repo, ReportLog.Repo]

config :report_log, ReportLog.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "report_log_repo",
  username: "postgres",
  hostname: "localhost"

config :report_log, PGChannel.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgres://postgres@localhost:5432/smoke_shop_dev"
